variable management_group_id {
  type        = string
  description = "The management group scope at which the policy will be defined. Defaults to current Subscription if omitted. Changing this forces a new resource to be created."
  default     = "Matthew - Azure Landing Zones"
}

locals {

  json_files = fileset("../../../../modules/policies/definitions", "*.json")
  json_data  = [ for f in local.json_files : jsondecode(file("../../../../modules/policies/definitions/${f}")) ]
  
}