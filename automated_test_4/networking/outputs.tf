output "vnet_id" {
  description = "The VNet id"
  value       = azurerm_virtual_network.test_vnet.id
}

output "subnets" {
  description = "Map of the subnet object to the subnet name"
  value       = { for subnet in azurerm_subnet.subnets : subnet.name => subnet }
}

output "nat_gateway_id" {
  description = "The NAT gateway id"
  value       = azurerm_nat_gateway.nat_gateway.id
}





