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
resource "azurerm_resource_group" "Management" {
  name     = var.name
  location = var.location
}

resource "azurerm_automation_account" "automation_account" {
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
  name                = var.ddosPlanName
  location            = var.location
  resource_group_name = azurerm_resource_group.Management.name
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storageAccountName
  resource_group_name      = azurerm_resource_group.Management.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
}