output "bastion_ip" {
  description = "The public IP for the bastion"
  value       = azurerm_public_ip.bastion_pub_ip.ip_address
}