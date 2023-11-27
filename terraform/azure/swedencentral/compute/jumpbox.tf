resource "azurerm_public_ip" "jumpbox_pip" {
  name                = "${var.prefix}-jumpbox-pip"
  resource_group_name = module.network.resource-group-name
  location            = module.basic.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic-jumpbox" {
  name                = "${var.prefix}-jumpbox-nic"
  location            = module.basic.location
  resource_group_name = module.network.resource-group-name

  ip_configuration {
    name                          = "${var.prefix}-ip-1"
    subnet_id                     = module.network.jumpbox-subnet-id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_pip.id
  }
}

resource "tls_private_key" "bootstrap_private_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.prefix}-jumpbox"
  location              = module.basic.location
  resource_group_name   = module.network.resource-group-name
  network_interface_ids = [azurerm_network_interface.nic-jumpbox.id]
  size                  = "Standard_B2s"
  admin_username        = var.admin-user

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.vm-sku
    version   = "latest"
  }

  os_disk {
    name    = "${var.prefix}-jumpbox-os"
    caching = "ReadWrite"
    # create_option     = "FromImage"
    storage_account_type = "Standard_LRS"
  }

  computer_name = "${var.prefix}-jumpbox"

  admin_ssh_key {
    username   = var.admin-user
    public_key = file("~/.ssh/id_rsa_azure.pub")
  }

  provisioner "local-exec" {
    command = templatefile("linux-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "${var.admin-user}",
      identityfile = "~/.ssh/id_rsa_azure"
    })
    interpreter = ["bash", "-c"]

  }

}