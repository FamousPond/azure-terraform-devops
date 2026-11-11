resource "azurerm_lb" "load_balancer" {
  name                = "Load-Balancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.web_pub_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_address_pool" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb_http_probe" {
  name            = "lb-http-probe"
  loadbalancer_id = azurerm_lb.load_balancer.id
  protocol        = "Http"
  port            = 8080
  request_path    = "/"
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "lb-rule"
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_address_pool.id]
  probe_id                       = azurerm_lb_probe.lb_http_probe.id
  disable_outbound_snat          = true
}