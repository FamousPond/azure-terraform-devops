# VNet similar to a vpc.
resource "azurerm_virtual_network" "test_vnet" {
  name                = "dev-vnet"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}

# link the private DNS zone to this VNet
resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_dns_to_vnet" {
  name                  = "link-key-vault-dns-to-vnet"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault_dns.name
  virtual_network_id    = azurerm_virtual_network.test_vnet.id
}

# Subnets
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "bastion-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "very_private_subnet" {
  name                 = "very-private-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Public IPs
resource "azurerm_public_ip" "web_pub_ip" {
  name                = "web-public-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_public_ip" "bastion_pub_ip" {
  name                = "bastion-public-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}

# NAT gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "nat-gateway"
  location            = var.location
  resource_group_name = var.rg_name
}
