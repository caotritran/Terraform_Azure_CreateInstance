output "public_ip_address" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "azure_vm_name" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.name
}