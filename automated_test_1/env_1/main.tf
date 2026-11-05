terraform {
  required_version = ">= 1.9"

  # required_providers are like the libraries terraform will use from the terraform registry (by default), or elsewhere?
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" } # This is telling terraform I want to use azure
  }

  backend "azurerm" {
    resource_group_name  = "tf_config_storage_rg"
    storage_account_name = "tfstore1126"
    container_name       = "tfstate1"
    key                  = "dev.tfstate"
    use_azuread_auth     = true
  }
}

# provider configures the specific provider.
provider "azurerm" {
  features {}
}

# This is an azure resource group.
resource "azurerm_resource_group" "example_rg" {
  name     = "rg-dev"
  location = "australiasoutheast"
}

# VNet similar to a vpc.
resource "azurerm_virtual_network" "test_vnet" {
  name                = "dev-vnet"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
  address_space       = ["10.0.0.0/16"]

}

# Outputs
output "virtual_network_id" {
  value = azurerm_virtual_network.test_vnet.id
}
