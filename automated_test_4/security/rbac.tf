# Create a role to read the key vault secrets
resource "azurerm_role_assignment" "vm_key_vault_reader" {
  for_each             = { for vm_name, vm_config in var.vms : vm_name => vm_config if vm_config.subnet == var.zone_to_access_kv }
  scope                = var.kv_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value.vm_principal_id
}
