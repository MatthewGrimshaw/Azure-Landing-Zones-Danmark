output "azurerm_policy_assignment" {
  description = ""
  value = [ for assignments in azurerm_management_group_policy_assignment.assignmnet : assignments.name ]
}
