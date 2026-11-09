# Random string to make the key vault name unique
resource "random_string" "key_vault_suffix" {
  length  = 6
  special = false
  upper   = false
}

# key vault
resource "azurerm_key_vault" "key_vault" {
  name                          = "tf-key-vault-${random_string.key_vault_suffix.result}"
  location                      = var.location
  resource_group_name           = var.rg_name
  rbac_authorization_enabled    = true
  sku_name                      = "standard"
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  public_network_access_enabled = false

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "private_endpoint_to_key_vault" {
  name                = "private-endpoint-to-key-vault"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = azurerm_subnet.very_private_subnet.id

  private_service_connection {
    name                           = "psc-key_vault"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]

  }
  private_dns_zone_group {
    name                 = "key-vault-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault_dns.id]
  }

}