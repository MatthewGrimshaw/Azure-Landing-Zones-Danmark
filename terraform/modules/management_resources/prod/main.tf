provider "azurerm" {
  features {}
}

terraform { 
 required_providers { 
     azurerm = { 
         source = "hashicorp/azurerm"
         version = ">= 2.96.0" 
     } 
 } 
}

# root mgmt group
data "azurerm_management_group" "root_management_group" {
  display_name = var.uai_role_assignment_scope
}

resource "azurerm_resource_group" "Management" {
  name     = var.name
  location = var.location
}

resource "azurerm_automation_account" "automation_account" {
  depends_on = [
    azurerm_resource_group.Management
  ]
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.Management.name
  sku_name            = "Basic"
  public_network_access_enabled = true
  local_authentication_enabled = false
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_network_ddos_protection_plan" "ddos" {
  depends_on = [
    azurerm_resource_group.Management
  ]
  name                = var.ddosPlanName
  location            = var.location
  resource_group_name = azurerm_resource_group.Management.name
}

resource "azurerm_storage_account" "storage" {
  depends_on = [
    azurerm_resource_group.Management
  ]
  name                     = var.storageAccountName
  resource_group_name      = azurerm_resource_group.Management.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
}

resource "azurerm_storage_container" "container" {
  name                  = var.storageContainerName
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "uai" {
  depends_on = [
    azurerm_resource_group.Management
  ]
  location            = var.location
  name                = var.userAssignedIdentityName
  resource_group_name = azurerm_resource_group.Management.name
}

resource "azurerm_role_assignment" "uai_role_assignment" {
  depends_on = [
    azurerm_user_assigned_identity.uai
  ]
  #role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
  role_definition_name = "Owner"
  principal_id       = azurerm_user_assigned_identity.uai.principal_id
  scope = data.azurerm_management_group.root_management_group.id
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  depends_on = [
    azurerm_resource_group.Management
  ]
  name                = var.workspaceName
  location            = var.location
  resource_group_name = azurerm_resource_group.Management.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  allow_resource_only_permissions  = true
}

# Link Log Analytics Workspace to Automation Account
resource "azurerm_log_analytics_linked_service" "autoacc_linked_log_workspace" {
  depends_on = [
    azurerm_log_analytics_workspace.log_analytics, 
    azurerm_automation_account.automation_account
  ]
  resource_group_name = azurerm_resource_group.Management.name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  read_access_id      = azurerm_automation_account.automation_account.id
}

# Enable Log Analytics solutions
resource "azurerm_log_analytics_solution" "update_solution" {
  depends_on = [
    azurerm_log_analytics_linked_service.autoacc_linked_log_workspace
  ]
  for_each = var.log_analytics_solutions

  solution_name       = each.value.name
  location            = var.location
  resource_group_name = azurerm_resource_group.Management.name
  #   workspace_id        = azurerm_log_analytics_workspace.ops.id
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${each.value.name}"
  }
}