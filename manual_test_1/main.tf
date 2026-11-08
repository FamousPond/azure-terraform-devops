terraform {
  required_version = ">= 1.9"

  # required_providers are like the libraries terraform will use from the terraform registry (by default), or elsewhere?
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" } # This is telling terraform I want to use azure
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
  name                = "vnet-dev"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
  address_space       = ["10.0.0.0/16"]

}

# Outputs
output "virtual_network_id" {
  value = azurerm_virtual_network.test_vnet.id
}
