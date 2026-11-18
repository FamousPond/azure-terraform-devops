output "vms" {
  description = "Maps the VM name to the VMs subnet name, NIC id, VM id and VM principal id"
  value = tomap({
    for nic_name, nic_data in local.nics : azurerm_linux_virtual_machine.vm[nic_name].name => {
      subnet          = nic_data.subnet
      nic_id          = azurerm_network_interface.nic[nic_name].id
      vm_id           = azurerm_linux_virtual_machine.vm[nic_name].id
      vm_principal_id = azurerm_linux_virtual_machine.vm[nic_name].identity[0].principal_id
    }
  })
}