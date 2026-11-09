# Bastion
resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-host"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Basic"

  ip_configuration {
    name                 = "ip-configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pub_ip.id
  }
}

# linux vm same as an ec2 instance
resource "azurerm_linux_virtual_machine" "web_vm" {
  name                = "web-vm"
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B2ps_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.web_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server-arm64"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "backend_vm" {
  name                = "backend-vm"
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B2ps_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.backend_nic.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server-arm64"
    version   = "latest"
  }
}
