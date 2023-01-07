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

    If($StandardOutput -match "Resource already managed by Terraform"){
      write-output "Script will continue"
    }
    If($StandardOutput -match "Error"){
      write-output "Errors detected"
    }
}


# Set Env Variables for terraform init to authenticate to Azure Storage
$env:ARM_CLIENT_ID=$ARM_CLIENT_ID
$env:ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
$env:ARM_TENANT_ID= $ARM_TENANT_ID
$env:ARM_USE_OIDC="true"

Write-Output $importDir

# get json file with resources to be imported
Set-Location $importDir
$resourcesToImport = Get-Content $importFile  | ConvertFrom-Json

# inititalise terraform
terraform init -backend-config storage_account_name=$storageAccountName -backend-config container_name=$containerName -backend-config resource_group_name=$ResourceGroupName -backend-config key=$tfStateFile

#import resources
foreach($resource in $resourcesToImport.properties.resource){

        switch ($resource.type){
            "azurerm_management_group"
            {
                $resourceId = (Get-AzManagementGroup -GroupId $resource.name).Id
                $resourcename = ($resource.name).Replace("-", "_")
            }
            "azurerm_resource_group"
            {
                $resourceId = (Get-AzResourceGroup -Name $resource.name).ResourceId
                $resourcename = $resource.name
            }
            "azurerm_automation_account" 
            {              
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.Automation/automationAccounts").ResourceId
                $resourcename = $resource.name
            }
            "azurerm_network_ddos_protection_plan"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.Network/ddosProtectionPlans").ResourceId
                $resourcename = $resource.name
            }
            "azurerm_storage_account"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.Storage/storageAccounts").ResourceId
                $resourcename = $resource.name
            }
        }

        write-output "Resources to be imported are:"
        write-output "$($resource.type).$($resourcename) $resourceId"
        $arguments="import `"$($resource.type).$($resourcename)`" $resourceId"
        
        # Check return code status
        $FileName = "terraform"
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.RedirectStandardError = $true
        $process.StartInfo.FileName = $FileName
        $process.StartInfo.Arguments = $arguments
        $process.StartInfo.WorkingDirectory = $importDir
        $process.Start()    
        $StandardError = $process.StandardError.ReadToEnd()
        $StandardOutput = $process.StandardOutput.ReadToEnd()  
        lastExitCode $StandardError $StandardOutput 
    }



