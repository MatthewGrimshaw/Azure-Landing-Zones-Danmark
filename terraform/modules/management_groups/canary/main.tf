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

resource "azurerm_management_group" "matthew_lz_canary" {
  display_name = var.matthew_lz_canary_display_name
  name = var.matthew_lz_canary_name
/* If you wish to use Subscription ID Mapping with Management Groups
  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ] 
*/
}

//parent = "matthew-lz-canary"
resource "azurerm_management_group" "matthew_lz_canary_decommmisioned" {
  display_name = var.matthew_lz_canary_decommmisioned_display_name
  name = var.matthew_lz_canary_decommmisioned_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary.id
}

resource "azurerm_management_group" "matthew_lz_canary_sandbox" {
  display_name = var.matthew_lz_canary_sandbox_display_name
  name = var.matthew_lz_canary_sandbox_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary.id
}

resource "azurerm_management_group" "matthew_lz_canary_platform" {
  display_name = var.matthew_lz_canary_platform_display_name
  name = var.matthew_lz_canary_platform_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary.id
}

resource "azurerm_management_group" "matthew_lz_canary_landing_zones" {
  display_name = var.matthew_lz_canary_landing_zones_display_name
  name = var.matthew_lz_canary_landing_zones_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary.id
}

//parent = "matthew-lz-canary-platform"

resource "azurerm_management_group" "matthew_lz_canary_connectivity" {
  display_name = var.matthew_lz_canary_connectivity_display_name
  name = var.matthew_lz_canary_connectivity_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_platform.id
}

resource "azurerm_management_group" "matthew_lz_canary_identity" {
  display_name = var.matthew_lz_canary_identity_display_name
  name = var.matthew_lz_canary_identity_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_platform.id
}

resource "azurerm_management_group" "matthew_lz_canary_management" {
  display_name = var.matthew_lz_canary_management_display_name
  name = var.matthew_lz_canary_management_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_platform.id
}

resource "azurerm_management_group" "matthew_lz_canary_security" {
  display_name = var.matthew_lz_canary_security_display_name
  name = var.matthew_lz_canary_security_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_platform.id
}

// parent = "matthew-lz-canary-landing-zones"

resource "azurerm_management_group" "matthew_lz_canary_corp" {
  display_name = var.matthew_lz_canary_corp_display_name
  name = var.matthew_lz_canary_corp_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_landing_zones.id
}

resource "azurerm_management_group" "matthew_lz_canary_corp_confidential" {
  display_name = var.matthew_lz_canary_corp_confidential_display_name
  name = var.matthew_lz_canary_corp_confidential_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_landing_zones.id
}

resource "azurerm_management_group" "matthew_lz_canary_online_confidential" {
  display_name = var.matthew_lz_canary_online_confidential_display_name
  name = var.matthew_lz_canary_online_confidential_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_landing_zones.id
}

resource "azurerm_management_group" "matthew_lz_canary_online" {
  display_name = var.matthew_lz_canary_online_display_name
  name = var.matthew_lz_canary_online_name
  parent_management_group_id = azurerm_management_group.matthew_lz_canary_landing_zones.id
}
