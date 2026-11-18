locals {
  nics = tomap({ for nic in flatten([
    for subnet, num_machines in var.machines : [
      for i in range(num_machines) : {
        subnet = subnet,
        index  = i + 1
      }
    ]
    ]) : "${nic.subnet}-${nic.index}" => nic
  })
}

# trivy:ignore:AZU-0068 NIC is associated with an ASG and that group then has an NSG
resource "azurerm_network_interface" "nic" {
  for_each            = local.nics
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnets[each.value.subnet]
    private_ip_address_allocation = "Dynamic"
  }
}

# linux vm same as an ec2 instance
resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = local.nics
  name                  = "${each.key}-vm"
  resource_group_name   = var.rg_name
  location              = var.location
  size                  = "Standard_B2ps_v2"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

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
