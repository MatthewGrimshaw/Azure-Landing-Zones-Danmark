provider "azurerm" {
  features {}
}

terraform { 
 required_providers { 
     azurerm = { 
         source = "hashicorp/azurerm"
         version = ">= 2.96.0" 
     } 
 } 
}
resource "azurerm_resource_group" "Management" {
  name     = var.name
  location = var.location
}