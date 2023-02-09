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
  display_name = var.management_group_id
}

resource azurerm_policy_set_definition setdef {
for_each = {for f in local.json_data : f.name => f}
  name = each.value.name
  policy_type = each.value.properties.policyType
  display_name = each.value.properties.displayName
  description  = each.value.properties.description
  management_group_id = data.azurerm_management_group.root_management_group.id 
  metadata = jsonencode(each.value.properties.metadata)
  parameters   = jsonencode(each.value.properties.parameters)

  dynamic policy_definition_reference {
    for_each = each.value.properties.policyDefinitions

    content {
      policy_definition_id = replace(policy_definition_reference.value.policyDefinitionId, "<prefix>", var.prefix)
      parameter_values = jsonencode(policy_definition_reference.value.parameters)
      reference_id = policy_definition_reference.value.policyDefinitionReferenceId
      policy_group_names = try(jsonencode(policy_definition_reference.value.groupNames), "")
    }
  } 

  dynamic "policy_definition_group" {
    for_each = each.value.properties.policyDefinitionGroups == null ? [1] : []

    content {
      name = try(policy_definition_group.value.name, "")
      display_name = try(policy_definition_group.value.display_name, "")
      category = try(policy_definition_group.value.category, "")
      description = try(policy_definition_group.value.description, "")
      additional_metadata_resource_id = try(policy_definition_group.value.additional_metadata_resource_id, "")
    }
  }
}