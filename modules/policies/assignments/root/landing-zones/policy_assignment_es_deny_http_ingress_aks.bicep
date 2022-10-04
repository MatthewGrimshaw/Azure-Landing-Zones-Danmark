targetScope = 'managementGroup'
resource Enforce_AKS_HTTPS 'Microsoft.Authorization/policyAssignments@2019-09-01' = {
  name: 'Enforce-AKS-HTTPS'
  properties: {
    description: 'Use of HTTPS ensures authentication and protects data in transit from network layer eavesdropping attacks. This capability is currently generally available for Kubernetes Service (AKS), and in preview for AKS Engine and Azure Arc enabled Kubernetes. For more info, visit https://aka.ms/kubepolicydoc.'
    displayName: 'Kubernetes clusters should be accessible only over HTTPS'
    notScopes: []
    parameters: {
      effect: {
        value: 'deny'
      }
    }
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d')
    enforcementMode: 'Default'
  }
  identity: {
    type: 'None'
  }
}