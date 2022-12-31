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
    $resourceType, #= "azurerm_management_group"
    $storageAccountName, #= "mgmtstorageqwerty",
    $ResourceGroupName, #= "Management",
    $containerName, #= "tfstate-canary"
    $tfStateFile
)

write-output $importFile
write-output $resourceType
write-output $storageAccountName
write-output $ResourceGroupName
write-output $containerName

# Find State File and Generate SAS Key
$Context = (Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $storageAccountName).Context
#$blobName = Get-AzStorageBlob -Container $containerName -Context $Context | Select-Object -Property Name
$FullUri = New-AzStorageBlobSASToken -Context $Context `
    -Container $containerName `
    -Blob $tfStateFile `
    -Permission racwd `
    -ExpiryTime (Get-Date).AddMinutes(30) `
    -FullUri

write-output $FullUri

$resourcesToImport = Get-Content $importFile  | ConvertFrom-Json 


foreach($resource in $resourcesToImport.properties.managementGroups){
    $resourceId = (Get-AzManagementGroup -GroupId $resource.name).Id
    write-output "Resources to be imported are:"
    write-output "$($resourceType).$($resource.name) $resourceId"
    terraform import -config=$FullUri "$($resourceType).$($resource.name)" $resourceId 
}


