targetScope = 'managementGroup'

param location string = deployment().location
param managementGroupId string
param root string

module GuestConfigWinBaseline '../.././../shared/policy-assignment.bicep' = {
  name: 'Guest-Configuration-Windows-Baseline'
  scope: managementGroup(managementGroupId)
  params: {
    location: location
    policyAssignmentName: 'GuestConfig-WinBaseline'
    policyDefinitionId: extensionResourceId(resourceId('Microsoft.Management/managementGroups', root), 'Microsoft.Authorization/policySetDefinitions/', 'be7a78aa-3e10-4153-a5fd-8c6506dbc821')
    parameters: {}
  }
}
