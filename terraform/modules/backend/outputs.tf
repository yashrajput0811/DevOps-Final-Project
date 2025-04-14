output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.tfstate.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.tfstate.name
}

output "container_name" {
  description = "Name of the storage container"
  value       = azurerm_storage_container.tfstate.name
} 