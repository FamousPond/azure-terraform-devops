# Bastion public IP
resource "azurerm_public_ip" "bastion_pub_ip" {
  name                = "bastion-public-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}

# Bastion host
resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-host"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Basic"

  ip_configuration {
    name                 = "ip-configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pub_ip.id
  }
}