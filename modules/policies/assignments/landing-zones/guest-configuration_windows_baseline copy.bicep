targetScope = 'managementGroup'

param location string = deployment().location
param managementGroupId string
param root string

module GuestConfigurationPolicies '../.././../shared/policy-assignment.bicep' = {
  name: 'Guest-Configuration-Policies'
  scope: managementGroup(managementGroupId)
  params: {
    location: location
    policyAssignmentName: 'GuestConfigPolicies'
    policyDefinitionId: extensionResourceId(resourceId('Microsoft.Management/managementGroups', root), 'Microsoft.Authorization/policySetDefinitions/', 'Configure-Guest-Configuration-Policies')
    parameters: {}
  }
}
