output "rg_name" {
  description = "The Name of the rg"
  value       = azurerm_resource_group.rg.name
}

output "rg_location" {
  description = "The location of rg"
  value       = azurerm_resource_group.rg.location
}
