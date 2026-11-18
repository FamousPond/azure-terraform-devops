# Network security groups
resource "azurerm_network_security_group" "web_sg" {
  name                = "web-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                   = "allow-http-internet"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "8080"
    # trivy:ignore:AZU-0047 Required to let the users connect to the website
    source_address_prefix                      = "Internet"
    destination_application_security_group_ids = [local.map_asgs["web"]]
  }

  security_rule {
    name                                       = "allow-lb-probe"
    priority                                   = 101
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "8080"
    source_address_prefix                      = "AzureLoadBalancer"
    destination_application_security_group_ids = [local.map_asgs["web"]]
  }

  security_rule {
    name                                       = "allow-bastion-ssh"
    priority                                   = 102
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefixes                    = var.bastion_subnet.address_prefixes
    destination_application_security_group_ids = [local.map_asgs["web"]]
  }

  security_rule {
    name                                       = "deny-inbound-vnet"
    priority                                   = 4096
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "Any"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_address_prefix                      = "VirtualNetwork"
    destination_application_security_group_ids = [local.map_asgs["web"]]
  }

}

resource "azurerm_network_security_group" "backend_sg" {
  name                = "backend-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                                       = "allow-ssh-from-bastion"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_address_prefixes                    = var.bastion_subnet.address_prefixes
    destination_application_security_group_ids = [local.map_asgs["backend"]]
  }

  security_rule {
    name                                       = "allow-from-web-machine"
    priority                                   = 101
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_application_security_group_ids      = [local.map_asgs["web"]]
    destination_application_security_group_ids = [local.map_asgs["backend"]]
  }

  security_rule {
    name                                       = "deny-inbound-vnet"
    priority                                   = 4096
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "Any"
    source_port_range                          = "*"
    destination_port_range                     = "*"
    source_address_prefix                      = "VirtualNetwork"
    destination_application_security_group_ids = [local.map_asgs["backend"]]
  }

}

resource "azurerm_network_security_group" "bastion_sg" {
  name                = "bastion-sg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                   = "allow-https-from-internet-inbound-sg"
    priority               = 101
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "443"
    # trivy:ignore:AZU-0047 Required by Azure Bastion to connect from Internet
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
    name                   = "allow-http-outbound-sg"
    priority               = 203
    direction              = "Outbound"
    access                 = "Allow"
    protocol               = "*"
    source_port_range      = "*"
    destination_port_range = "80"
    source_address_prefix  = "*"
    # trivy:ignore:AZU-0051 Required by Azure Bastion to connect to outbound web
    destination_address_prefix = "Internet"
  }
}
