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
  metadata = each.value.properties.metadata
  parameters   = jsonencode(each.value.properties.parameters)
  policy_definition_reference = jsonencode(each.value.properties.policyDefinitions)
}