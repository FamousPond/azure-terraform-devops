# VNet similar to a vpc.
resource "azurerm_virtual_network" "test_vnet" {
  name                = "dev-vnet"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]

  # Can declare a subnet here or as a resource "azurerm_subnet" but can't do both
  subnet {
    name             = "dev-subnet-1"
    address_prefixes = ["10.0.1.0/24"]
    security_group   = azurerm_network_security_group.test_sg.id
  }

  subnet {
    name             = "dev-subnet-2"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.test_sg.id
  }
}

resource "azurerm_public_ip" "test_pub_ip" {
  name                = "dev-public-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}
