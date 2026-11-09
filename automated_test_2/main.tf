resource "azurerm_resource_group" "dev_rg" {
  name     = var.rg_name
  location = var.location
}