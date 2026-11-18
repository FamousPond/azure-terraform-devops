terraform {
  backend "azurerm" {
    resource_group_name  = "tf_config_storage_rg"
    storage_account_name = "tfstore1126"
    container_name       = "tfstate1"
    key                  = "dev.tfstate1"
    use_azuread_auth     = true
  }
}

resource "azurerm_resource_group" "dev_rg" {
  name     = var.rg_name
  location = var.location
}

module "providers" {
  source = "./providers"
}

module "networking" {
  source = "./networking"

  rg_name  = azurerm_resource_group.dev_rg.name
  location = var.location

  vnet_cidr = ["10.0.0.0/16"]
  zones     = ["AzureBastionSubnet", "web", "backend", "kv-subnet"]
}

module "compute" {
  source = "./compute"

  rg_name  = azurerm_resource_group.dev_rg.name
  location = var.location

  machines       = { "web" : 1, "backend" : 1 }
  subnets        = { for subnet in module.networking.subnets : subnet.name => subnet.id }
  ssh_public_key = var.ssh_public_key

}

module "bastion" {
  source = "./bastion"

  rg_name  = azurerm_resource_group.dev_rg.name
  location = var.location

  bastion_subnet_id = module.networking.subnets["AzureBastionSubnet"].id
}

module "kv" {
  source = "./key_vault"

  rg_name  = azurerm_resource_group.dev_rg.name
  location = var.location

  vnet_id      = module.networking.vnet_id
  kv_subnet_id = module.networking.subnets["kv-subnet"].id
}


module "lb" {
  source = "./loadbalancer"

  rg_name  = azurerm_resource_group.dev_rg.name
  location = var.location

  lb_zone = "web"
  vms     = module.compute.vms
}

module "security" {
  source = "./security"

  rg_name  = azurerm_resource_group.dev_rg.name
  location = var.location

  subnets           = { for subnet in module.networking.subnets : subnet.name => subnet.id }
  vms               = module.compute.vms
  nat_gateway_id    = module.networking.nat_gateway_id
  bastion_subnet    = module.networking.subnets["AzureBastionSubnet"]
  kv_id             = module.kv.kv_id
  zone_to_access_kv = "backend"
}
