resource "azurerm_network_interface" "web_1_nic" {
  name                = "web-1-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.11"
  }
}

resource "azurerm_network_interface" "web_2_nic" {
  name                = "web-2-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.12"
  }
}

resource "azurerm_network_interface" "backend_nic" {
  name                = "backend-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.11"
  }
}
