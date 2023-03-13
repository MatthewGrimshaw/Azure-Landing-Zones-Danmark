output "azurerm_policy_definition" {
  description = ""
  value = [ for setdefs in azurerm_policy_set_definition.setdef_policy : setdefs.name ]
}

output "azurerm_policy_definition_reg_comp" {
  description = ""
  value = [ for setdefs in azurerm_policy_set_definition.setdef_regcomp : setdefs.name ]
}