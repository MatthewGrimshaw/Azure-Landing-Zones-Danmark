<#
        .SYNOPSIS
        Imports existing Azure Resources into the Terraform State file to get them under source control.

        .DESCRIPTION
        Imports existing Azure Resources into the Terraform State file to get them under source control.

        .EXAMPLE
        PS> New-GithubFerderation.ps1

        .EXAMPLE
        PS> New-GithubFerderation.ps1
#>

param (
    [String]
    $importFile, # = ".\modules\management_groups\canary\import_resources.json"'
    $resourceType, # = "azurerm_management_group"
    $storageAccountName, # = "mgmtstorageqwerty"
    $ResourceGroupName, # = "Management"
    $containerName, # = "tfstate-canary"
    $tfStateFile # = "terraform.tfstate"
)

write-output $importFile
write-output $resourceType
write-output $storageAccountName
write-output $ResourceGroupName
write-output $containerName
write-output $tfStateFile

$resourcesToImport = Get-Content $importFile  | ConvertFrom-Json 

terraform init -backend-config storage_account_name=$storageAccountName -backend-config container_name=$containerName -backend-config resource_group_name=$ResourceGroupName -backend-config key=$tfStateFile

foreach($resource in $resourcesToImport.properties.managementGroups){
    $resourceId = (Get-AzManagementGroup -GroupId $resource.name).Id
    write-output "Resources to be imported are:"
    write-output "$($resourceType).$(($resource.name).Replace("-", "_")) $resourceId"
    terraform import "$($resourceType).$(($resource.name).Replace("-", "_"))" $resourceId 
}


