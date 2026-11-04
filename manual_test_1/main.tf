terraform {
  required_version = ">= 1.9"

  # required_providers are like the libraries terraform will use from the terraform registry (by default), or elsewhere?
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" } # This is telling terraform I want to use azure
    random  = { source = "hashicorp/random", version = "~> 3.6" }  # this is telling terraform I want to use this random library
  }
}

# provider configures the specific provider.
provider "azurerm" {
  features {}
}

# resources have 2 arguments. 1. resource type. 2. resource name.
# Interestingly you don't need to say which provider you are referring to.
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# This is an azure resource group.
resource "azurerm_resource_group" "example_rg" {
  name     = "rg-dev"
  location = "australiasoutheast"
}

# This is a storage account which is just a space to store things like s3 but gives more optionality. (s3 only stores blobs)
resource "azurerm_storage_account" "storage" {
  name                     = "sttflearn${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.example_rg.name
  location                 = azurerm_resource_group.example_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Outputs
output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}
