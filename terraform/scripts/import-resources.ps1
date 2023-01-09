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
    if($StandardError){
        Write-Error "Standard Error"
        Write-Error $StandardError
        exit(1)
    }

    If($StandardOutput -match "Resource already managed by Terraform"){
      write-output "Terraform already manages this resource. Import Script will continue"
    }
    ElseIf($StandardOutput -match "Error"){
      write-Error "Errors detected"
      Write-Error $StandardOutput
      exit(1)
    }
    Else{
        Write-Output "Standard Output : "
        Write-Output $StandardOutput
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
            }
            "azurerm_resource_group"
            {
                $resourceId = (Get-AzResourceGroup -Name $resource.name).ResourceId
            }
            "azurerm_automation_account"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.Automation/automationAccounts").ResourceId
            }
            "azurerm_network_ddos_protection_plan"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.Network/ddosProtectionPlans").ResourceId
            }
            "azurerm_storage_account"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.Storage/storageAccounts").ResourceId
            }
            "azurerm_storage_container"
            {
                $ctx=(Get-AzStorageAccount -ResourceGroupName $resource.resource_group -Name $resource.storage_account_name).Context
                $resourceId = $($ctx.blobEndpoint)+$((Get-AzStorageContainer -Name $resource.name -Context $ctx).Name)
            }
            "azurerm_user_assigned_identity"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.ManagedIdentity/userAssignedIdentities").ResourceId
            }
            "azurerm_log_analytics_workspace"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.OperationalInsights/workspaces").ResourceId
            }
            "azurerm_log_analytics_solution"
            {
                $resourceId = (Get-AzResource -ResourceGroupName $resource.resource_group  -Name $resource.name | Where-Object -Property ResourceType -eq -Value "Microsoft.OperationsManagement/solutions").ResourceId
            }
        }

        if(!$resourceId -or $null -eq $resourceId)
            {
                write-error "Resource ID not found for $($resource.name). Please check it exists. Script will exit"
                exit(1)
            }

        write-output "Resources to be imported are:"
        write-output "$($resource.type).$($resource.tfconfig_name) $resourceId"
        $arguments="import `"$($resource.type).$($resource.tfconfig_name)`" $resourceId"

        # Check return code status
        $FileName = "terraform"
        $process = New-Object System.Diagnostics.Process$resource.name
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.RedirectStandardError = $true
        $process.StartInfo.FileName = $FileName
        $process.StartInfo.Arguments = $arguments
        $process.StartInfo.WorkingDirectory = $importDir
        $process.Start() | Out-Null
        $StandardError = $process.StandardError.ReadToEnd()
        $StandardOutput = $process.StandardOutput.ReadToEnd()
        lastExitCode $StandardError $StandardOutput
    }



