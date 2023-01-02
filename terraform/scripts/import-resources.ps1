<#
        .SYNOPSIS
        Imports existing Azure Resources into the Terraform State file to get them under source control.

        .DESCRIPTION
        Imports existing Azure Resources into the Terraform State file to get them under source control.

        .EXAMPLE
        PS> import-resources.ps1 import-resources.ps1 -importDir "terraform/modules/management_groups/canary" -importFile "import_resources.json"  -resourceType "azurerm_management_group" -storageAccountName ${{ secrets.STORAGE_ACCOUNT_NAME }} -ResourceGroupName ${{ secrets.RESOURCE_GROUP_NAME }} -containerName ${{ secrets.CONTAINER_NAME }} -tfStateFile ${{ secrets.KEY }} -ARM_CLIENT_ID ${{ secrets.AZURE_CLIENT_ID }} -ARM_SUBSCRIPTION_ID ${{ secrets.AZURE_MANAGEMENT_SUBSCRIPTION_ID }} -ARM_TENANT_ID ${{ secrets.AZURE_TENANT_ID }}
#>

param (
    [String]
    $importDir,
    $importFile, # = ".\modules\management_groups\canary\import_resources.json"'
    $resourceType, # = "azurerm_management_group"
    $storageAccountName, # = "mgmtstorageqwerty"
    $ResourceGroupName, # = "Management"
    $containerName, # = "tfstate-canary"
    $tfStateFile, # = "terraform.tfstate"
    $ARM_CLIENT_ID,
    $ARM_SUBSCRIPTION_ID,
    $ARM_TENANT_ID
    #$ARM_CLIENT_SECRET
)

write-output $importDir
write-output $importFile
write-output $resourceType
write-output $storageAccountName
write-output $ResourceGroupName
write-output $containerName
write-output $tfStateFile

$env:ARM_CLIENT_ID=$ARM_CLIENT_ID
$env:ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
$env:ARM_TENANT_ID= $ARM_TENANT_ID
#$env:ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET
$env:ARM_USE_OIDC="true"

write-output "$(gci env:ARM_*)"

Set-Location $importDir
$resourcesToImport = Get-Content $importFile  | ConvertFrom-Json 

terraform init -backend-config storage_account_name=$storageAccountName -backend-config container_name=$containerName -backend-config resource_group_name=$ResourceGroupName -backend-config key=$tfStateFile

foreach($resource in $resourcesToImport.properties.managementGroups){
    $resourceId = (Get-AzManagementGroup -GroupId $resource.name).Id
    write-output "Resources to be imported are:"
    write-output "$($resourceType).$(($resource.name).Replace("-", "_")) $resourceId"
    terraform import "$($resourceType).$(($resource.name).Replace("-", "_"))" $resourceId 
}


