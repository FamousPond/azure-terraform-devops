# Security group same as AWS
resource "azurerm_network_security_group" "test_sg" {
  name                = "dev-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "sg-allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
