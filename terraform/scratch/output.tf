output "azurerm_storage_account" {
  description = ""
  value       = azurerm_storage_account.storage.name
}

output "azurerm_storage_container_canary" {
  description = ""
  value       = azurerm_storage_container.container_canary.name
}

output "azurerm_storage_container_prod" {
  description = ""
  value       = azurerm_storage_container.container_prod.name
}

