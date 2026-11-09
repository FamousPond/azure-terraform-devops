# Application security groups
resource "azurerm_application_security_group" "web_asg" {
  name                = "web-asg"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name
}

resource "azurerm_application_security_group" "backend_asg" {
  name                = "backend-asg"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name
}

# Network security groups
resource "azurerm_network_security_group" "to_web_machine" {
  name                = "to-web-machine-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  security_rule {
    name                                       = "allow-ssh-from-bastion-sg"
    priority                                   = 101
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefixes                    = azurerm_subnet.bastion_subnet.address_prefixes
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }

  security_rule {
    name                                       = "allow-http-from-internet-sg"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "8080"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }
}

resource "azurerm_network_security_group" "to_backend_machine" {
  name                = "to-backend-machine-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  security_rule {
    name                                       = "allow-ssh-from-bastion-sg"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefixes                    = azurerm_subnet.bastion_subnet.address_prefixes
    destination_application_security_group_ids = [azurerm_application_security_group.backend_asg.id]
  }

  security_rule {
    name                                       = "allow-from-web-machine-sg"
    priority                                   = 101
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_application_security_group_ids      = [azurerm_application_security_group.web_asg.id]
    destination_application_security_group_ids = [azurerm_application_security_group.backend_asg.id]
  }
}

resource "azurerm_network_security_group" "to_bastion" {
  name                = "to-bastion-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  security_rule {
    name                       = "allow-ssh-inbound-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.bastion_subnet.address_prefixes[0]
  }

  security_rule {
    name                       = "allow-https-from-internet-inbound-sg"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https-from-gateway-manager-inbound-sg"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-vnet-to-vnet-inbound-sg"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["5701", "8080"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow-https-from-load-balancer-inbound-sg"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-ssh-rdp-outbound-sg"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow-azure-cloud-outbound-sg"
    priority                   = 201
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }

  security_rule {
    name                       = "allow-bastion-communication-outbound-sg"
    priority                   = 202
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["5701", "8080"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow-http-outbound-sg"
    priority                   = 203
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }






}
