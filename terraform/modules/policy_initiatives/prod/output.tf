output "azurerm_policy_definition" {
  description = ""
  value = [ for setdefs in azurerm_policy_set_definition.setdef : setdefs.name ]
}

output "result" {
  value = local.json_data
}