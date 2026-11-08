# Network interface and application security group associations
resource "azurerm_network_interface_application_security_group_association" "web_nic_asg" {
  network_interface_id          = azurerm_network_interface.web_nic.id
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
