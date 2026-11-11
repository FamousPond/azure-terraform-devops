# Network interface and application security group associations
resource "azurerm_network_interface_application_security_group_association" "web_1_nic_asg" {
  network_interface_id          = azurerm_network_interface.web_1_nic.id
  application_security_group_id = azurerm_application_security_group.web_asg.id
}

resource "azurerm_network_interface_application_security_group_association" "web_2_nic_asg" {
  network_interface_id          = azurerm_network_interface.web_2_nic.id
  application_security_group_id = azurerm_application_security_group.web_asg.id
}

resource "azurerm_network_interface_application_security_group_association" "backend_nic_asg" {
  network_interface_id          = azurerm_network_interface.backend_nic.id
  application_security_group_id = azurerm_application_security_group.backend_asg.id
}

# Subnet and Network security group associations
resource "azurerm_subnet_network_security_group_association" "public_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.to_web_machine.id
}

resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.to_backend_machine.id
}

resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.to_bastion.id
}

# NAT gateway and subnet associations
resource "azurerm_subnet_nat_gateway_association" "private_subnet_nat_gateway_assoc" {
  subnet_id      = azurerm_subnet.private_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

# Load balancer address pool
resource "azurerm_network_interface_backend_address_pool_association" "web_1_lb_assoc" {
  network_interface_id    = azurerm_network_interface.web_1_nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_address_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web_2_lb_assoc" {
  network_interface_id    = azurerm_network_interface.web_2_nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_address_pool.id
}