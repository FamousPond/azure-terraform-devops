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

resource "azurerm_application_security_group" "bastion_asg" {
  name                = "bastion-asg"
  location            = var.location
  resource_group_name = var.rg_name
}

# Network security groups
resource "azurerm_network_security_group" "from_bastion" {
  name                = "from-bastion-sg"
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
    source_application_security_group_ids      = [azurerm_application_security_group.bastion_asg.id]
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id, azurerm_application_security_group.backend_asg.id]
  }
}

resource "azurerm_network_security_group" "from_web_machine" {
  name                = "from-web-machine-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-from-web-machine-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_application_security_group_ids      = [azurerm_application_security_group.web_asg.id]
    destination_application_security_group_ids = [azurerm_application_security_group.backend_asg.id]
  }
}

resource "azurerm_network_security_group" "from_internet" {
  name                = "from-internet-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "allow-from-internet-sg"
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
