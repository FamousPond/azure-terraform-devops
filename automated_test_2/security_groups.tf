# Application security groups
resource "azurerm_application_security_group" "web_asg" {
  name                = "web-asg"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_application_security_group" "backend_asg" {
  name                = "backend-asg"
  location            = var.location
  resource_group_name = var.rg_name
}

# Network security groups
resource "azurerm_network_security_group" "to_web_machine" {
  name                = "to-web-machine-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-ssh-from-bastion-sg"
    priority                   = 99
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes     = [azurerm_subnet.bastion_subnet.address_prefixes]
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }

  security_rule {
    name                       = "allow-http-from-internet-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }
}

resource "azurerm_network_security_group" "to_backend_machine" {
  name                = "to-backend-machine-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-ssh-from-bastion-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes      = [azurerm_subnet.bastion_subnet.address_prefixes]
    destination_application_security_group_ids = [azurerm_application_security_group.backend_asg.id]
  }

  security_rule {
    name                       = "allow-from-web-machine-sg"
    priority                   = 99
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_application_security_group_ids      = [azurerm_application_security_group.web_asg.id]
    destination_application_security_group_ids = [azurerm_application_security_group.backend_asg.id]
  }
}

resource "azurerm_network_security_group" "to_bastion" {
  name                = "to-bastion-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-ssh-to-bastion-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = [azurerm_subnet.bastion_subnet.address_prefixes]
  }
}
