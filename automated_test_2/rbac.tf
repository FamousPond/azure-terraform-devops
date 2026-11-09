# Create a role to read the key vault secrets
resource "azurerm_role_assignment" "vm_key_vault_reader" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Reader"
  principal_id         = azurerm_linux_virtual_machine.backend_vm.identity[0].principal_id
}
