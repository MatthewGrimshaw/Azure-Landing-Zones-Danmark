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


resource "azurerm_storage_account" "storage" {
  name                     = var.storageAccountName
  resource_group_name      = "Management"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  enable_https_traffic_only = true
  min_tls_version = "TLS1_2"
  public_network_access_enabled = true
  access_tier = "Hot"
  shared_access_key_enabled = true
  is_hns_enabled = false  
  nfsv3_enabled = false
  large_file_share_enabled = false

}

resource "azurerm_storage_container" "container_canary" {
  name                  = var.storageContainerName_canary
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_prod" {
  name                  = var.storageContainerName_prod
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.workspaceName
  location            = var.location
  resource_group_name = "Management"
  sku                 = "PerGB2018"
  retention_in_days   = 30
  allow_resource_only_permissions  = true
}


resource "azurerm_log_analytics_solution" "log_analytics_solution" {

  for_each = var.log_analytics_solutions

  solution_name       = each.value.name
  location            = var.location
  resource_group_name = "Management"
  #   workspace_id        = azurerm_log_analytics_workspace.ops.id
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${each.value.name}"
  }
}


