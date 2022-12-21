# Canary Root Management Group
variable "matthew_lz_canary_display_name" {
  type = string
  default = "Matthew - Azure Landing Zones - Canary"
}

variable "matthew_lz_canary_name" {
  type = string
  default = "matthew-lz-canary"
}

# Parent = "matthew-lz-canary"
variable "matthew_lz_canary_decommmisioned_display_name" { 
  type = string
  default = "Decommmisioned"
}

variable "matthew_lz_canary_decommmisioned_name" { 
  type = string
  default = "matthew-lz-canary-decommmisioned"
}

# Parent = "matthew-lz-canary"
variable "matthew_lz_canary_sandbox_display_name" { 
  type = string
  default = "Sandbox"
}

variable "matthew_lz_canary_sandbox_name" { 
  type = string
  default = "matthew-lz-canary-sandbox"
}

# Parent = "matthew-lz-canary"
variable "matthew_lz_canary_platform_display_name" { 
  type = string
  default = "Platform"
}

variable "matthew_lz_canary_platform_name" { 
  type = string
  default = "matthew-lz-canary-platform"
}

# Parent = "matthew-lz-canary"
variable "matthew_lz_canary_landing_zones_display_name" { 
  type = string
  default = "Landing Zones"
}

variable "matthew_lz_canary_landing_zones_name" { 
  type = string
  default = "matthew-lz-canary-landing-zones"
}

# Parent = "matthew-lz-canary-platform"
variable "matthew_lz_canary_connectivity_display_name" { 
  type = string
  default = "Connectivity"
}

variable "matthew_lz_canary_connectivity_name" { 
  type = string
  default = "matthew-lz-canary-connectivity"
}

# Parent = "matthew-lz-canary-platform"
variable "matthew_lz_canary_identity_display_name" { 
  type = string
  default = "Identity"
}

variable "matthew_lz_canary_identity_name" { 
  type = string
  default = "matthew-lz-canary-identity"
}

# Parent = "matthew-lz-canary-platform"
variable "matthew_lz_canary_management_display_name" { 
  type = string
  default = "Management"
}

variable "matthew_lz_canary_management_name" { 
  type = string
  default = "matthew-lz-canary-management"
}

# Parent = "matthew-lz-canary-platform"
variable "matthew_lz_canary_security_display_name" { 
  type = string
  default = "Security"
}

variable "matthew_lz_canary_security_name" { 
  type = string
  default = "matthew-lz-canary-security"
}

# Parent = "matthew-lz-canary-landing-zones"
variable "matthew_lz_canary_corp_display_name" { 
  type = string
  default = "Corp"
}

variable "matthew_lz_canary_corp_name" { 
  type = string
  default = "matthew-lz-canary-corp"
}

# Parent = "matthew-lz-canary-landing-zones"
variable "matthew_lz_canary_corp_confidential_display_name" { 
  type = string
  default = "Corp Confidential"
}

variable "matthew_lz_canary_corp_confidential_name" { 
  type = string
  default = "matthew-lz-canary-corp-confidential"
}

# Parent = "matthew-lz-canary-landing-zones"
variable "matthew_lz_canary_online_display_name" { 
  type = string
  default = "Online"
}

variable "matthew_lz_canary_online_name" { 
  type = string
  default = "matthew-lz-canary-online"
}

# Parent = "matthew-lz-canary-landing-zones"
variable "matthew_lz_canary_online_confidential_display_name" { 
  type = string
  default = "Online Confidential"
}

variable "matthew_lz_canary_online_confidential_name" { 
  type = string
  default = "matthew-lz-canary-online-confidential"
}