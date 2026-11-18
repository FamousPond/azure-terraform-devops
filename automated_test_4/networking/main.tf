# VNet similar to a vpc.
resource "azurerm_virtual_network" "test_vnet" {
  name                = "dev-vnet"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.vnet_cidr
}

# Subnet for each of the input zones
resource "azurerm_subnet" "subnets" {
  count                = length(var.zones)
  name                 = var.zones[count.index]
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = [cidrsubnet("10.0.0.0/16", 8, count.index)]
}

# NAT gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "nat-gateway"
  location            = var.location
  resource_group_name = var.rg_name
}
