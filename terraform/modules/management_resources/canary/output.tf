output "name" {
  description = ""
  value       = azurerm_resource_group.Management.name
}

output "location" {
  description = ""
  value       = azurerm_resource_group.Management.location
}

output "id" {
  description = ""
  value       = azurerm_resource_group.Management.id
}

output "automation_account_name" {
  description = ""
  value       = azurerm_automation_account.automation_account.name
}

output "aurerm_network_ddos_protection_plan" {
  description = ""
  value       = azurerm_network_ddos_protection_plan.ddos.name
}

output "azurerm_storage_account" {
  description = ""
  value       = azurerm_storage_account.storage.name
}

output "azurerm_storage_container" {
  description = ""
  value       = azurerm_storage_container.container.name
}

output "azurerm_user_assigned_identity" {
  description = ""
  value       = azurerm_user_assigned_identity.uai.principal_id
}

output "azurerm_role_assignment" {
  description = ""
  value = azurerm_role_assignment.uai_role_assignment.id
}
output "azurerm_log_analytics_workspace" {
  description = ""
  value = azurerm_log_analytics_workspace.log_analytics.id
}
