output "azurerm_policy_definition" {
  description = ""
  value = [ for defs in azurerm_policy_definition.def : defs.name ]
}

output "result" {
  value = local.json_data
}