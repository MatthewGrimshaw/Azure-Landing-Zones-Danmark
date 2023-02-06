<#
        .SYNOPSIS
        Imports existing Azure PÆolicies into the Terraform State file to get them under source control.

        .DESCRIPTION
        Imports existing Azure RPolicies into the Terraform State file to get them under source control.

        .EXAMPLE
        PS> import-policies.ps1  -importDir "terraform/modules/policy_definitions/canary" -policyDir "../../../../modules/policies/definitions"  -mgmtGroupName "lz-canary" -storageAccountName ${{ secrets.STORAGE_ACCOUNT_NAME }} -ResourceGroupName ${{ secrets.RESOURCE_GROUP_NAME }} -containerName ${{ secrets.CONTAINER_NAME }} -tfStateFile ${{ secrets.KEY }} -ARM_CLIENT_ID ${{ secrets.AZURE_CLIENT_ID }} -ARM_SUBSCRIPTION_ID ${{ secrets.AZURE_MANAGEMENT_SUBSCRIPTION_ID }} -ARM_TENANT_ID ${{ secrets.AZURE_TENANT_ID }}

#>

param (
    [String]
    $importDir,
    $PolicyDir,
    $mgmtGroupName,
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

$PolicyDir = "C:\Users\matgri\repos\mattthew-alz-danmark\Azure-Landing-Zones-Danmark\modules\policies\definitions"
$importDir = "C:\Users\matgri\repos\mattthew-alz-danmark\Azure-Landing-Zones-Danmark\terraform\modules\policy_definitions\canary"
Write-Output $importDir

# get json file with resources to be imported
#Set-Location $importDir

# inititalise terraform
terraform init -backend-config storage_account_name=$storageAccountName -backend-config container_name=$containerName -backend-config resource_group_name=$ResourceGroupName -backend-config key=$tfStateFile


# get json file with resources to be imported
Push-Location
Set-Location $importDir

# import policies from directory
ForEach($customPolicy in (Get-ChildItem -Path $policyDir)){   
    $policy = Get-AzPolicyDefinition -ManagementGroupName $mgmtGroupName -Custom | Where-Object Name -eq (Get-Content $customPolicy.FullName | ConvertFrom-Json).Name
    $resourceId = $policy.ResourceId

    if(!$resourceId -or $null -eq $resourceId)
    {
        write-error "Resource ID not found for $((Get-Content $customPolicy.Name | ConvertFrom-Json).Name). Please check it exists. Script will exit"
        exit(1)
    }

    # policies are an array and need an index
    write-output "azurerm_policy_definition.def[\`"$($policy.name)\`"] $resourceId"
    $arguments="import azurerm_policy_definition.def[\`"$($policy.name)\`"] $resourceId"
    write-output $arguments

    # Check return code status
    $FileName = "terraform"
    $process = New-Object System.Diagnostics.Process
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

Pop-Location