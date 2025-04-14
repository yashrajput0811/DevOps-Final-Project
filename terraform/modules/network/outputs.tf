output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value = {
    prod   = azurerm_subnet.prod.id
    test   = azurerm_subnet.test.id
    dev    = azurerm_subnet.dev.id
    admin  = azurerm_subnet.admin.id
  }
} 