variable "name" {
  description = ""
  type = string
  default = "Management"
}

variable "location" {
  description = ""
  type = string
  default = "westeurope"
}

variable "automation_account_name" {
  description = ""
  type = string
  default = "ufstlzcanary"
}


variable "ddosPlanName" {
  description = ""
  type = string
  default = "ufstlzcanary"
}


variable "storageAccountName" {
  description = ""
  type = string
  default = "ufstlzcanary"
}

variable "userAssignedIdentityName" {
  description = ""
  type = string
  default = "uai"
}

variable "userAssignedIdentityRoleAssignmentName" {
  description = ""
  type = string
  default = "uairoleassignment"
}

variable "workspaceName" {
  description = ""
  type = string
  default = "ufstlzcanary"
}

variable "log_analytics_solutions" {
  description = ""
  type = map(object({
    name = string
  }))
  default = {
    "AgentHealthAssessment" ={name="AgentHealthAssessment"},
    "AzureActivity" ={name="AzureActivity"},
    "ChangeTracking" ={name="ChangeTracking"},
    "Security" ={name="Security"},
    "SecurityInsights" ={name="SecurityInsights"},
    "ServiceMap" ={name="ServiceMap"},
    "SQLAdvancedThreatProtection" ={name="SQLAdvancedThreatProtection"},
    "SQLAssessment" ={name="SQLAssessment"},
    "SQLVulnerabilityAssessment" ={name="SQLVulnerabilityAssessment"},
    "Updates" ={name="Updates"},
    "VMInsights" ={name="VMInsights"},

  }
}