provider "azurerm" {
  features {}
}

module "basic" {
  source          = "../globals"
  subscription-id = ""
}

