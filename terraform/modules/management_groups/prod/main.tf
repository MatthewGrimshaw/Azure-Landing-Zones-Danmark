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

resource "azurerm_management_group" "matthew_lz" {
  display_name = var.matthew_lz_display_name
  name = var.matthew_lz_name
/* If you wish to use Subscription ID Mapping with Management Groups
  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ] 
*/
}

//parent = "matthew-lz"
resource "azurerm_management_group" "matthew_lz_decommmisioned" {
  display_name = var.matthew_lz_decommmisioned_display_name
  name = var.matthew_lz_decommmisioned_name
  parent_management_group_id = azurerm_management_group.matthew_lz.id
}

resource "azurerm_management_group" "matthew_lz_sandbox" {
  display_name = var.matthew_lz_sandbox_display_name
  name = var.matthew_lz_sandbox_name
  parent_management_group_id = azurerm_management_group.matthew_lz.id
}

resource "azurerm_management_group" "matthew_lz_platform" {
  display_name = var.matthew_lz_platform_display_name
  name = var.matthew_lz_platform_name
  parent_management_group_id = azurerm_management_group.matthew_lz.id
}

resource "azurerm_management_group" "matthew_lz_landing_zones" {
  display_name = var.matthew_lz_landing_zones_display_name
  name = var.matthew_lz_landing_zones_name
  parent_management_group_id = azurerm_management_group.matthew_lz.id
}

//parent = "matthew-lz-platform"

resource "azurerm_management_group" "matthew_lz_connectivity" {
  display_name = var.matthew_lz_connectivity_display_name
  name = var.matthew_lz_connectivity_name
  parent_management_group_id = azurerm_management_group.matthew_lz_platform.id
}

resource "azurerm_management_group" "matthew_lz_identity" {
  display_name = var.matthew_lz_identity_display_name
  name = var.matthew_lz_identity_name
  parent_management_group_id = azurerm_management_group.matthew_lz_platform.id
}

resource "azurerm_management_group" "matthew_lz_management" {
  display_name = var.matthew_lz_management_display_name
  name = var.matthew_lz_management_name
  parent_management_group_id = azurerm_management_group.matthew_lz_platform.id
}

resource "azurerm_management_group" "matthew_lz_security" {
  display_name = var.matthew_lz_security_display_name
  name = var.matthew_lz_security_name
  parent_management_group_id = azurerm_management_group.matthew_lz_platform.id
}

// parent = "matthew-lz-landing-zones"

resource "azurerm_management_group" "matthew_lz_corp" {
  display_name = var.matthew_lz_corp_display_name
  name = var.matthew_lz_corp_name
  parent_management_group_id = azurerm_management_group.matthew_lz_landing_zones.id
}

resource "azurerm_management_group" "matthew_lz_corp_confidential" {
  display_name = var.matthew_lz_corp_confidential_display_name
  name = var.matthew_lz_corp_confidential_name
  parent_management_group_id = azurerm_management_group.matthew_lz_landing_zones.id
}

resource "azurerm_management_group" "matthew_lz_online_confidential" {
  display_name = var.matthew_lz_online_confidential_display_name
  name = var.matthew_lz_online_confidential_name
  parent_management_group_id = azurerm_management_group.matthew_lz_landing_zones.id
}

resource "azurerm_management_group" "matthew_lz_online" {
  display_name = var.matthew_lz_online_display_name
  name = var.matthew_lz_online_name
  parent_management_group_id = azurerm_management_group.matthew_lz_landing_zones.id
}