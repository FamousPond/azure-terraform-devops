output "web_public_ip" {
  value = azurerm_public_ip.web_pub_ip.ip_address
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_pub_ip.ip_address
}
