variable location {
  type        = string
  description = "The Azure Region where the Policy Assignment should exist. Changing this forces a new Policy Assignment to be created"
  default     = "westeurope"
}

locals {
  resource_ids = {
    log_analytics_workspace = "/subscriptions/6a509a0a-f0b6-4e8c-88d3-7108d0f37309/resourceGroups/Management/providers/Microsoft.OperationalInsights/workspaces/mgmtworkspace"
    email_security_contact =  "management@azurelandingzones.com"
    export_resource_group_name =  "AzurePlatform"
    ddosPlan = "/subscriptions/6a509a0a-f0b6-4e8c-88d3-7108d0f37309/resourceGroups/Management/providers/Microsoft.Network/ddosProtectionPlans/ufstlzcanary"
    userAssignedIdentity = "/subscriptions/6a509a0a-f0b6-4e8c-88d3-7108d0f37309/resourceGroups/Management/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai"
    automationAccountName = "mgmtautomationaccount"
    mgmtResourceGroupName = "Management"
    logAnalyticsWorkspaceName = "mgmtworkspace"
    logAnalayticsDataRetion = 30
    logAnalyticsSKU = "pergb2018"

  }

  azurerm_management_group_assignments = [
      {
          name = "AMA-For-Hybrid-VMs"
          display_name = "AMA-For-Hybrid-VMs-Assignment"
          policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/59e9c3eb-d8df-473b-8059-23fd38ddd0f0"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({
              workspaceId = {value =local.resource_ids.log_analytics_workspace}
          }))
          identity_type = ["UserAssigned"]
          identity_ids = [local.resource_ids.userAssignedIdentity]
      },
      {
          name = "Defender-For-Cloud"
          display_name = "Defender-For-Cloud-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policySetDefinitions/Configure-Defender-For-Cloud"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({
              emailSecurityContact = {value =local.resource_ids.email_security_contact}
              logAnalytics = {value =local.resource_ids.log_analytics_workspace}
              exportResourceGroupName = {value =local.resource_ids.export_resource_group_name}
              exportResourceGroupLocation = {value =local.resource_ids.export_resource_group_name}
          }))
          identity_type = ["UserAssigned"]
          identity_ids = [local.resource_ids.userAssignedIdentity]
      },
      {
          name = "Enable-DDoS-VNET"
          display_name = "Enable-DDoS-VNET-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({
              ddosPlan = {value =local.resource_ids.ddosPlan}
              effect = {value ="Modify"}
          }))
          identity_type = ["UserAssigned"]
          identity_ids = [local.resource_ids.userAssignedIdentity]
      },
      {
          name = "Guest-Attestation"
          display_name = "Guest-Attestation-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({}))
          identity_type = ["UserAssigned"]
          identity_ids = [local.resource_ids.userAssignedIdentity]
      },
      {
          name = "Guest-Configuration"
          display_name = "Guest-Configuration-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({}))
          identity_type = ["UserAssigned"]
          identity_ids = [local.resource_ids.userAssignedIdentity]
      },
      {
          name = "Deploy-Log-Analytics"
          display_name = "Deploy-Log-Analytics-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-management"
          parameters = jsonencode(merge({
            effect = {value ="DeployIfNotExists"}
            workspaceName = {value =local.resource_ids.logAnalyticsWorkspaceName}
            automationAccountName = {value =local.resource_ids.automationAccountName}
            workspaceRegion = {value =var.location}
            automationRegion = {value =var.location}
            dataRetention = {value =local.resource_ids.logAnalayticsDataRetion}
            sku = {value =local.resource_ids.logAnalyticsSKU}
            rgName = {value =local.resource_ids.mgmtResourceGroupName}
          }))
          identity_type = []
      },
      {
          name = "DenyRDPFromInternetIdnty"
          display_name = "Deny-RDP-From-Internet-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-identity"
          parameters = jsonencode(merge({
            effect = {value ="Deny"}
          }))
          identity_type = []
      },
      {
          name = "Deny-Public-IP-Identity"
          display_name = "Deny-Public-IP-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-identity"
          parameters = jsonencode(merge({
            effect = {value ="Deny"}
          }))
          identity_type = []
      },
      {
          name = "DenyRDPFromInternetLZ"
          display_name = "Deny-RDP-From-Internet-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-landing-zones"
          parameters = jsonencode(merge({
            effect = {value ="Deny"}
          }))
          identity_type = []
      },
      {
          name = "Deny-IP-Forwarding"
          display_name = "Deny-IP-Forwarding-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-landing-zones"
          parameters = jsonencode(merge({}))
          identity_type = []
      },
      {
          name = "Deny-DataBricks-Pip"
          display_name = "Deny-DataBricks-Pip-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/Deny-Databricks-NoPublicIp"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-corp"
          parameters = jsonencode(merge({
            effect = {value ="Deny"}
          }))
          identity_type = []
      },
      {
          name = "Deny-DataBricks-Sku"
          display_name = "Deny-DataBricks-Sku-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/Deny-Databricks-Sku"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-corp"
          parameters = jsonencode(merge({
            effect = {value ="Deny"}
          }))
          identity_type = []
      },
      {
          name = "Deny-DataBricks-Vnet"
          display_name = "Deny-DataBricks-Vnet-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/Deny-Databricks-VirtualNetwork"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-corp"
          parameters = jsonencode(merge({
            effect = {value ="Deny"}
          }))
          identity_type = []
      },
      {
          name = "Deny-Public-Endpoints"
          display_name = "Deny-Public-Endpoints-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-corp"
          parameters = jsonencode(merge({}))
          identity_type = []
      },
      {
          name = "Deny-Public-IP-Corp"
          display_name = "Deny-Public-IP-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicIP"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz-corp"
          parameters = jsonencode(merge({
            effect = {value ="Deny"}
          }))
          identity_type = []
      },
      {
          name = "AuditCISGroup1Level1"
          display_name = "Audit-CIS-Implementation Group-1-Level-1-controls-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policySetDefinitions/Audit CIS Implementation Group 1 Level 1 controls"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({}))
          identity_type = []
      },
      {
          name = "AuditCISGroup1Level2"
          display_name = "Audit-CIS-Implementation Group-1-Level-2-controls-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policySetDefinitions/Audit CIS Implementation Group 1 Level 2 controls"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({}))
          identity_type = []
      },
            {
          name = "AuditCISGroup2Level1"
          display_name = "Audit-CIS-Implementation Group-2-Level-1-controls-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policySetDefinitions/Audit CIS Implementation Group 2 Level 1 controls"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({}))
          identity_type = []
      },
      {
          name = "AuditCISGroup2Level2"
          display_name = "Audit-CIS-Implementation Group-2-Level-2-controls-Assignment"
          policy_definition_id = "/providers/Microsoft.Management/managementGroups/matthew-lz/providers/Microsoft.Authorization/policySetDefinitions/Audit CIS Implementation Group 2 Level 2 controls"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({}))
          identity_type = []
      },
      {
          name = "CIS_Benchmark_v1.4.0"
          display_name = "CIS Microsoft Azure Foundations Benchmark v1.4.0-Assignment"
          policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/c3f5c4d9-9a1d-4a99-85c0-7f93e384d5c5"
          management_group_id  = "/providers/Microsoft.Management/managementGroups/matthew-lz"
          parameters = jsonencode(merge({}))
          identity_type = []
      }
  ]
}