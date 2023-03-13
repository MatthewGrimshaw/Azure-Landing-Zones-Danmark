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

# root mgmt group
data "azurerm_management_group" "root_management_group" {
  display_name = var.management_group_id
}

resource azurerm_policy_set_definition setdef_regcomp {
for_each = {for f in local.json_map : f.name => f if f.category == "Regulatory Compliance"}
  name = each.value.element.name
  policy_type = each.value.element.properties.policyType
  display_name = each.value.element.properties.displayName
  description  = each.value.element.properties.description
  management_group_id = data.azurerm_management_group.root_management_group.id
  metadata = jsonencode(each.value.element.properties.metadata)
  parameters   = jsonencode(each.value.element.properties.parameters)

  dynamic policy_definition_reference {
    for_each = each.value.element.properties.policyDefinitions

    content {
      policy_definition_id = replace(policy_definition_reference.value.policyDefinitionId, "<prefix>", var.prefix)
      parameter_values = jsonencode(policy_definition_reference.value.parameters)
      reference_id = policy_definition_reference.value.policyDefinitionReferenceId
      policy_group_names = policy_definition_reference.value.groupNames
    }
  }

  dynamic "policy_definition_group" {
    for_each = each.value.element.properties.policyDefinitionGroups
    content {
      name = policy_definition_group.value.name
      additional_metadata_resource_id = policy_definition_group.value.additionalMetadataId
   }
  }
}

resource azurerm_policy_set_definition setdef_policy {
for_each = {for f in local.json_map : f.name => f if f.category != "Regulatory Compliance"}
  name = each.value.element.name
  policy_type = each.value.element.properties.policyType
  display_name = each.value.element.properties.displayName
  description  = each.value.element.properties.description
  management_group_id = data.azurerm_management_group.root_management_group.id
  metadata = jsonencode(each.value.element.properties.metadata)
  parameters   = jsonencode(each.value.element.properties.parameters)

  dynamic policy_definition_reference {
    for_each = each.value.element.properties.policyDefinitions

    content {
      policy_definition_id = replace(policy_definition_reference.value.policyDefinitionId, "<prefix>", var.prefix)
      parameter_values = jsonencode(policy_definition_reference.value.parameters)
      reference_id = policy_definition_reference.value.policyDefinitionReferenceId
      policy_group_names = policy_definition_reference.value.groupNames
    }
  }
}