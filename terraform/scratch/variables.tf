
variable "location" {
  description = ""
  type = string
  default = "westeurope"
}

variable "storageAccountName" {
  description = ""
  type = string
  default = "tarstmgmtstorageqwerty"
}

variable "storageContainerName_canary" {
  description = ""
  type = string
  default = "tarsttfstatecanary"
}

variable "storageContainerName_prod" {
  description = ""
  type = string
  default = "tarsttfstateprod"
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


variable "workspaceName" {
  description = ""
  type = string
  default = "tarstmgmtworkspace"
}