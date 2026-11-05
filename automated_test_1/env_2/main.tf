terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }

  backend "azurerm" {
    resource_group_name  = "tf_config_storage_rg"
    storage_account_name = "tfstore1126"
    container_name       = "tfstate1"
    key                  = "dev.tfstate1"
    use_azuread_auth     = true
  }

}

provider "azurerm" {
  features {}
}

# resource group
resource "azurerm_resource_group" "test_rg" {
  name     = "dev-rg"
  location = "australiaeast"
}

# Security group same as AWS
resource "azurerm_network_security_group" "test_sg" {
  name                = "dev-sg"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  security_rule {
    name                       = "sg-allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VNet similar to a vpc.
resource "azurerm_virtual_network" "test_vnet" {
  name                = "dev-vnet"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  address_space       = ["10.0.0.0/16"]

  # Can declare a subnet here or as a resource "azurerm_subnet" but can't do both
  subnet {
    name             = "dev-subnet-1"
    address_prefixes = ["10.0.1.0/24"]
    security_group   = azurerm_network_security_group.test_sg.id
  }

  subnet {
    name             = "dev-subnet-2"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.test_sg.id
  }
}

# local variables to be used
locals {

  #  map subnet names to ids because you can't id each individually.
  subnet_ids = {
    for subnet in azurerm_virtual_network.test_vnet.subnet : subnet.name => subnet.id
  }
}

resource "azurerm_public_ip" "test_pub_ip" {
  name                = "dev-public-ip"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_interface" "test_nic_1" {
  name                = "dev-nic-1"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_ids["dev-subnet-1"]
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.17"
    public_ip_address_id          = azurerm_public_ip.test_pub_ip.id
  }
}

resource "azurerm_network_interface" "test_nic_2" {
  name                = "dev-nic-2"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_ids["dev-subnet-2"]
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.245"
  }
}

# linux vm same as an ec2 instance
resource "azurerm_linux_virtual_machine" "test_vm_1" {
  name                = "dev-vm-1"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  size                = "Standard_B2ps_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.test_nic_1.id,
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

resource "azurerm_linux_virtual_machine" "test_vm_2" {
  name                = "dev-vm-2"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  size                = "Standard_B2ps_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.test_nic_2.id,
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


output "public_ip" {
  value = azurerm_public_ip.test_pub_ip.ip_address
}
