
variable "location" {
  description = ""
  type = string
  default = "westeurope"
}

variable "storageAccountName" {
  description = ""
  type = string
  default = "mgmtstorageqwerty"
}

variable "storageContainerName_canary" {
  description = ""
  type = string
  default = "tfstatecanary"
}

variable "storageContainerName_prod" {
  description = ""
  type = string
  default = "tfstateprod"
}
