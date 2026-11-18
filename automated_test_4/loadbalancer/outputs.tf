output "lb_ip" {
  description = "Public IP for the load balancer"
  value       = azurerm_public_ip.lb_ip.ip_address
}