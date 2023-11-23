provider "azurerm" {
  features {}
}

module "basic" {
  source          = "../globals"
  subscription-id = ""
}

module "network" {
  source       = "../networking"
  my_public_ip = ""
}