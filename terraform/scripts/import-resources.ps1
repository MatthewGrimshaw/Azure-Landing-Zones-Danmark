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
    $importFile, #= ".\modules\management_groups\canary\import_resources.json",
    $resourceType #= "azurerm_management_group"
)

write-output $importFile
$resourcesToImport = Get-Content $importFile  | ConvertFrom-Json 


foreach($resource in $resourcesToImport.properties.managementGroups){
    $resourceId = (Get-AzManagementGroup -GroupId $resource.name).Id
    write-output "Resources to be imported are:"
    write-output "$($resourceType).$($resource.name) $resourceId"
    #terraform import "$($resourceType).$($resource.name) $resourceId"
}


