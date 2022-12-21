# Canary Root Management Group
variable "matthew_lz_display_name" {
  type = string
  default = "Matthew - Azure Landing Zones - Canary"
}

variable "matthew_lz_name" {
  type = string
  default = "matthew-lz"
}

# Parent = "matthew-lz"
variable "matthew_lz_decommmisioned_display_name" { 
  type = string
  default = "Decommmisioned"
}

variable "matthew_lz_decommmisioned_name" { 
  type = string
  default = "matthew-lz-decommmisioned"
}

# Parent = "matthew-lz"
variable "matthew_lz_sandbox_display_name" { 
  type = string
  default = "Sandbox"
}

variable "matthew_lz_sandbox_name" { 
  type = string
  default = "matthew-lz-sandbox"
}

# Parent = "matthew-lz"
variable "matthew_lz_platform_display_name" { 
  type = string
  default = "Platform"
}

variable "matthew_lz_platform_name" { 
  type = string
  default = "matthew-lz-platform"
}

# Parent = "matthew-lz"
variable "matthew_lz_landing_zones_display_name" { 
  type = string
  default = "Landing Zones"
}

variable "matthew_lz_landing_zones_name" { 
  type = string
  default = "matthew-lz-landing-zones"
}

# Parent = "matthew-lz-platform"
variable "matthew_lz_connectivity_display_name" { 
  type = string
  default = "Connectivity"
}

variable "matthew_lz_connectivity_name" { 
  type = string
  default = "matthew-lz-connectivity"
}

# Parent = "matthew-lz-platform"
variable "matthew_lz_identity_display_name" { 
  type = string
  default = "Identity"
}

variable "matthew_lz_identity_name" { 
  type = string
  default = "matthew-lz-identity"
}

# Parent = "matthew-lz-platform"
variable "matthew_lz_management_display_name" { 
  type = string
  default = "Management"
}

variable "matthew_lz_management_name" { 
  type = string
  default = "matthew-lz-management"
}

# Parent = "matthew-lz-platform"
variable "matthew_lz_security_display_name" { 
  type = string
  default = "Security"
}

variable "matthew_lz_security_name" { 
  type = string
  default = "matthew-lz-security"
}

# Parent = "matthew-lz-landing-zones"
variable "matthew_lz_corp_display_name" { 
  type = string
  default = "Corp"
}

variable "matthew_lz_corp_name" { 
  type = string
  default = "matthew-lz-corp"
}

# Parent = "matthew-lz-landing-zones"
variable "matthew_lz_corp_confidential_display_name" { 
  type = string
  default = "Corp Confidential"
}

variable "matthew_lz_corp_confidential_name" { 
  type = string
  default = "matthew-lz-corp-confidential"
}

# Parent = "matthew-lz-landing-zones"
variable "matthew_lz_online_display_name" { 
  type = string
  default = "Online"
}

variable "matthew_lz_online_name" { 
  type = string
  default = "matthew-lz-online"
}

# Parent = "matthew-lz-landing-zones"
variable "matthew_lz_online_confidential_display_name" { 
  type = string
  default = "Online Confidential"
}

variable "matthew_lz_online_confidential_name" { 
  type = string
  default = "matthew-lz-online-confidential"
}