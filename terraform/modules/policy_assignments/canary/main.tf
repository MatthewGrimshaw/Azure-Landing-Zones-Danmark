provider "azurerm" {
  features {}
}

terraform {
 required_providers {
     azurerm = {
         source = "hashicorp/azurerm"
         #version = ">= 2.96.0"
         version = "3.43.0"
     }
 }
}

resource "azurerm_management_group_policy_assignment" "assignmnet" {
  for_each = {for f in local.azurerm_management_group_assignments : f.name => f}
    name = each.value.name
    display_name = each.value.display_name
    policy_definition_id = each.value.policy_definition_id
    management_group_id  = each.value.management_group_id
    location = var.location
    parameters = each.value.parameters

    dynamic "identity" {
        for_each = each.value.identity_type
        content {
            type = identity.value
            identity_ids = each.value.identity_ids
      }
    }
}
