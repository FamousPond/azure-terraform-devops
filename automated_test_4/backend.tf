terraform {
  backend "azurerm" {
    resource_group_name  = "tf_config_storage_rg"
    storage_account_name = "tfstore1126"
    container_name       = "tfstate1"
    key                  = "dev.tfstate1"
    use_azuread_auth     = true
  }
}
