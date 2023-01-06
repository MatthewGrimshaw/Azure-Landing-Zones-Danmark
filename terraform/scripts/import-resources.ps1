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
    $importFile,
    $resourceType,
    $storageAccountName,
    $ResourceGroupName,
    $containerName,
    $tfStateFile,
    $ARM_CLIENT_ID,
    $ARM_SUBSCRIPTION_ID,
    $ARM_TENANT_ID
)

function lastExitCode {
    Param(
        $StandardError,    
        $StandardOutput
    )

            Write-Output "Standard Output : "
            Write-Output $StandardOutput
            Write-Output "Standard Error"
            Write-Output $StandardError 

            If($StandardError  -match "Resource already managed by Terraform"){
                write-output "Script will continue"
            }
}


# Set Env Variables for terraform init to authenticate to Azure Storage
$env:ARM_CLIENT_ID=$ARM_CLIENT_ID
$env:ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
$env:ARM_TENANT_ID= $ARM_TENANT_ID
$env:ARM_USE_OIDC="true"


# Terraform process details
$FileName = "terrafrom"
$process = New-Object System.Diagnostics.Process
$process.StartInfo.UseShellExecute = $false
$process.StartInfo.RedirectStandardOutput = $true
$process.StartInfo.RedirectStandardError = $true
$process.StartInfo.FileName = $FileName
$process.StartInfo.Arguments = $Arguments


Write-Output $importDir

# get json file with resources to be imported
Set-Location $importDir
$resourcesToImport = Get-Content $importFile  | ConvertFrom-Json

terraform init -backend-config storage_account_name=$storageAccountName -backend-config container_name=$containerName -backend-config resource_group_name=$ResourceGroupName -backend-config key=$tfStateFile

# Check return code status
lastExitCode $arguments $importDir

If($resourceType -eq "azurerm_management_group"){
    foreach($resource in $resourcesToImport.properties.managementGroups){
        $resourceId = (Get-AzManagementGroup -GroupId $resource.name).Id
        write-output "Resources to be imported are:"
        write-output "$($resourceType).$(($resource.name).Replace("-", "_")) $resourceId"
        $arguments="import '$($resourceType).$(($resource.name).Replace("-", "_"))' $resourceId"
        
        # Check return code status
        $process.StartInfo.FileName = $FileName
        $process.StartInfo.Arguments = $arguments
        $process.Start()    
        $StandardError = $process.StandardError.ReadToEnd()
        $StandardOutput = $process.StandardOutput.ReadToEnd()  
        lastExitCode $StandardError $StandardOutput 
    }
}
else{
    foreach($resource in $resourcesToImport.properties.resource){
        if($resource.type -eq "azurerm_resource_group"){
            $resourceId = (Get-AzResourceGroup -Name $resource.name).ResourceId
        }
        else{
            $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group -Name $resource.name).ResourceId
        }
        write-output "Resources to be imported are:"
        write-output "$($resource.type).$($resource.name) $resourceId"
        $arguments="import '$($resource.type).$($resource.name)' $resourceId"
        
        # Check return code status
        $process.StartInfo.FileName = $FileName
        $process.StartInfo.Arguments = $arguments
        $process.Start()    
        $StandardError = $process.StandardError.ReadToEnd()
        $StandardOutput = $process.StandardOutput.ReadToEnd()  
        lastExitCode $StandardError $StandardOutput 
    }
}


