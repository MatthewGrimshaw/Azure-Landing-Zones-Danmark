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


resource azurerm_policy_definition def {
for_each =  { for f in local.json_data : f.name => f }  
  name         = each.value.name
  policy_type  = each.value.properties.policyType
  mode         = each.value.properties.mode
  display_name = each.value.properties.displayName
  description  = each.value.properties.description
  metadata     = jsonencode(each.value.properties.metadata)
  policy_rule  = jsonencode(each.value.properties.policyRule)
  parameters   = jsonencode(each.value.properties.parameters) 
  management_group_id = data.azurerm_management_group.root_management_group.id

   lifecycle {
    create_before_destroy = true
  }

  timeouts {
    read = "10m"
  }
}