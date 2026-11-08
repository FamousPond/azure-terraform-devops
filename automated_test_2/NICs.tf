locals {
  #  map subnet names to ids because you can't id each individually.
  subnet_ids = {
    for subnet in azurerm_virtual_network.test_vnet.subnet : subnet.name => subnet.id
  }
}

resource "azurerm_network_interface" "test_nic_1" {
  name                = "dev-nic-1"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_ids["dev-subnet-1"]
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.17"
    public_ip_address_id          = azurerm_public_ip.test_pub_ip.id
  }
}

resource "azurerm_network_interface" "test_nic_2" {
  name                = "dev-nic-2"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_ids["dev-subnet-2"]
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.245"
  }
}
