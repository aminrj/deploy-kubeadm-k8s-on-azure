output "network-nsg-id" {
  value = azurerm_network_security_group.nsg.id
}

output "jumpbox-subnet-id" {
  value = azurerm_subnet.jumpbox-subnet.id
}

output "resource-group-name" {
  value = azurerm_resource_group.k8s-resources.name
}
