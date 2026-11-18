# Application security groups
resource "azurerm_application_security_group" "asg" {
  for_each            = var.subnets
  name                = each.key
  location            = var.location
  resource_group_name = var.rg_name
}

# Network interface and application security group associations
resource "azurerm_network_interface_application_security_group_association" "nic_asg" {
  for_each                      = var.vms
  network_interface_id          = each.value.nic_id
  application_security_group_id = azurerm_application_security_group.asg[each.value.subnet].id
}

# NAT gateway and subnet associations
resource "azurerm_subnet_nat_gateway_association" "gateway_assoc" {
  for_each       = var.subnets
  subnet_id      = each.value
  nat_gateway_id = var.nat_gateway_id
}

locals {
  map_nsgs = { "web" : azurerm_network_security_group.web_sg.id, "backend" : azurerm_network_security_group.backend_sg.id }
  map_asgs = { "web" : azurerm_application_security_group.asg["web"].id, "backend" : azurerm_application_security_group.asg["backend"].id }
}

# Associate non bastion subnet NSGs
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = var.subnets
  subnet_id                 = each.value
  network_security_group_id = local.map_nsgs[each.key]
}

# Associate bastion NSGs
resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_assoc" {
  subnet_id                 = var.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion_sg.id
}


