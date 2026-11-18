# Load balancer public IP
resource "azurerm_public_ip" "lb_ip" {
  name                = "lb-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}

# The load balancer
resource "azurerm_lb" "load_balancer" {
  name                = "Load-Balancer"
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

# Load balancer backend address pool
resource "azurerm_lb_backend_address_pool" "lb_address_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "BackEndAddressPool"
}

# Associating the NICs with the load balancer backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "lb_assoc" {
  for_each                = { for vm_name, vm_config in var.vms : vm_name => vm_config if vm_config.subnet == var.lb_zone }
  network_interface_id    = each.value.nic_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_address_pool.id
}

# Load balancer http probe
resource "azurerm_lb_probe" "lb_http_probe" {
  name            = "lb-http-probe"
  loadbalancer_id = azurerm_lb.load_balancer.id
  protocol        = "Http"
  port            = 8080
  request_path    = "/"
}

# Load balancer rule maps port 80 to port 8080
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "lb-rule"
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_address_pool.id]
  probe_id                       = azurerm_lb_probe.lb_http_probe.id
  disable_outbound_snat          = true
}