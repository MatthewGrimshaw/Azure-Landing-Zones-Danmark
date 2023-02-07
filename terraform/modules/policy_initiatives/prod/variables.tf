variable management_group_id {
  type        = string
  description = "The management group scope at which the policy initative will be defined. Defaults to current Subscription if omitted. Changing this forces a new resource to be created."
  default     = "Matthew - Azure Landing Zones - Canary"
}

locals {

  json_files = fileset("../../../../modules/policies/initiatives", "*.json")
  json_data  = [ for f in local.json_files : jsondecode(file("../../../../modules/policies/initiatives/${f}")) ]
  
}