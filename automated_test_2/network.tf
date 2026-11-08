# VNet similar to a vpc.
resource "azurerm_virtual_network" "test_vnet" {
  name                = "dev-vnet"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name = "bastion-subnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "public_subnet" {
  name = "public-subnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private_subnet" {
  name = "private-subnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "very_private_subnet" {
  name = "very-private-subnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes = ["10.0.3.0/24"]
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
