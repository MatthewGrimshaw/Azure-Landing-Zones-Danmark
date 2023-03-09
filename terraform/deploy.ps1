Connect-AzAccount -Tenant '4f8875af-ac0b-46ee-8a73-3634138f5818'
az login --tenant '4f8875af-ac0b-46ee-8a73-3634138f5818'
az account -set subscription "ME-MngEnv077352-matgri-1"

az account list

# create storage account and containers for the state file
$storageAccountName = 'mgmtstorageqwerty'
$resourceGroup = 'Management'
az storage account create -n $storageAccountName -g $resourceGroup -l westeurope --sku Standard_RAGRS
az storage container create -n 'tfstatecanary' --account-name $storageAccountName
az storage container create -n 'tfstateprod' --account-name $storageAccountName

Push-Location
Set-Location .\terraform\scratch

# terrafrom init
terraform init

$env:TF_LOG="DEBUG"
$env:TF_LOG_PATH="C:\tmp\terraform.log"

# terraform plan
terraform plan -out assignmnet.tfplan




#terraform apply
terraform apply assignmnet.tfplan

Pop-Location


### Onboarding

# get the terraform

$resourcesToImport = Get-Content .\modules\management_groups\canary\import_resources.json | ConvertFrom-Json

foreach($resource in $resourcesToImport.properties.managementGroups){
    write-output $resource.name
    write-output $resource.value
    write-output " "
    write-output (Get-AzManagementGroup -GroupName $resource.value).Id
}


Get-Member -MemberType NoteProperty | ForEach-Object {
    write-output $_.Name
    write-output $_.
    write-output " "
    terraform import terraform_id azure_resource_id
}


$wkspace = Get-AzOperationalInsightsWorkspace -Name "ufstlzcanary" -ResourceGroupName "Management"

$wkspace.WorkspaceFeatures


Get-AzAutomationAccount -Name "ufstlzcanary" -ResourceGroupName "Management"

$resourceID = (Get-AzOperationalInsightsLinkedService -ResourceGroupName "Management" -WorkspaceName "ufstlzcanary").id
$resourceID = $resourceID.Replace("linkedservices","linkedServices")

$resourceId = (Get-AzResource -ResourceGroupName "Management"  -Name "ufstlzcanary" | Where-Object -Property ResourceType -eq -Value "Microsoft.Automation/automationAccounts").ResourceId
Set-AzOperationalInsightsLinkedService -ResourceGroupName "Management" -WorkspaceName "mgmtworkspace" -LinkedServiceName "automation" -WriteAccessResourceId $resourceId

$resourceId = (Get-AzResource -ResourceGroupName "Management"  -Name "VMInsights(mgmtworkspace)" | Where-Object -Property ResourceType -eq -Value "Microsoft.OperationsManagement/solutions").ResourceId


terraform import azurerm_log_analytics_solution.log_analytics_solution "/subscriptions/6a509a0a-f0b6-4e8c-88d3-7108d0f37309/resourceGroups/Management/providers/Microsoft.OperationsManagement/solutions/VMInsights(mgmtworkspace)"

terraform import azurerm_log_analytics_solution.log_analytics_solution "/subscriptions/6a509a0a-f0b6-4e8c-88d3-7108d0f37309/resourceGroups/Management/providers/Microsoft.OperationsManagement/solutions/AgentHealthAssessment(mgmtworkspace)"


terraform import module.iam.aws_iam_user.user[\"bill\"] bill

terraform import aws_iam_user.                  user[\"bill\"]         bill

terraform --% import azurerm_log_analytics_solution.log_analytics_solution[\"VMInsights(mgmtworkspace)\"] "/subscriptions/6a509a0a-f0b6-4e8c-88d3-7108d0f37309/resourceGroups/Management/providers/Microsoft.OperationsManagement/solutions/VMInsights(mgmtworkspace)"

terraform --% import azurerm_log_analytics_solution.log_analytics_solution[\"AgentHealthAssessment(mgmtworkspace)\"] "/subscriptions/6a509a0a-f0b6-4e8c-88d3-7108d0f37309/resourceGroups/Management/providers/Microsoft.OperationsManagement/solutions/AgentHealthAssessment(mgmtworkspace)"


/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleAssignments/00000000-0000-0000-0000-000000000000
"/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"


#$objectId = (Get-AzADServicePrincipal -DisplayName 'uai').Appid
Get-AzRoleAssignment -ObjectId 'b479e543-4eaf-48a0-8fa4-293d2c0a5c0b'
Get-AzRoleAssignment -ServicePrincipalName 'uai'
Get-AzRoleAssignment -SignInName 'uai'
Get


$resourceId = (Get-AzRoleAssignment -Scope '/providers/Microsoft.Management/managementGroups/matthew-lz-canary' | Where-Object {($_.RoleDefinitionId -eq "8e3af657-a8ff-443c-a75c-2fe8c4bcb635") -and ($_.DisplayName -eq 'uai')}).RoleAssignmentId
$resourceId = (Get-AzRoleAssignment -Scope '/providers/Microsoft.Management/managementGroups/matthew-lz' | Where-Object {($_.RoleDefinitionId -eq "8e3af657-a8ff-443c-a75c-2fe8c4bcb635") -and ($_.DisplayName -eq 'uai')}).RoleAssignmentId



-Property RoleDefinitionId -eq -Value "8e3af657-a8ff-443c-a75c-2fe8c4bcb635" -and -Property -DisplayName -eq -Value 'uai'

#### Document - get in the right format ######
$mgmtGrp = "matthew-lz"
$defintion = Get-AzPolicySetDefinition -Name 'Audit CIS Implementation Group 2 Level 2 controls' -ManagementGroupName $mgmtGrp
$assignmnetName = "AuditCISGroup2Level2"
$CISLevel = "2"
$CISGroup = "1"

$masterArray = @()

foreach ($PolicyDefintion in $defintion.Properties.PolicyDefinitions){
    $object1 = New-Object PSObject
    # CIS Control Family
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "CIS Control Family" -Value ""
    #write-host "CIS Control Family"
    # CIS Control Title
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "CIS Control Title" -Value ""
    #write-host "CIS Control Title"
    # CIS Control ID
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "CIS Control ID" -Value ""
    #write-host "CIS Control ID"
    # Description
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Description" -Value ""
    #write-host "Description"
    # Control Domain
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Control Domain" -Value ""
    #write-host "Control Domain"
    # Control Name
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Control Name" -Value ""
    #write-host "Control Name"
    # Level
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Control Level" -Value $CISLevel
    #Write-host "CIS Level" $CISLevel
    # Group
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Control Group" -Value $CISGroup
    #Write-host "CIS Group" $CISGroup
    # CIS Revision
    $string = $PolicyDefintion.groupNames | Out-String
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Azure CIS Revision" -Value  $string
    #write-host "Azure CIS Revision:" $PolicyDefintion.groupNames
    # Audit Name
    $Policy = Get-AzPolicyDefinition -Id $PolicyDefintion.policyDefinitionId
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Azure Audit Policy Name:" -Value $Policy.Properties.DisplayName
    #write-host "Azure Policy Name:" $Policy.Properties.DisplayName
    # Audit Description
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Azure Audit Policy Description:" -Value $Policy.Properties.Description
    #write-host "Azure Policy Description:" $Policy.Properties.Description
    # Audit Guid
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Azure Audit Policy Id" -Value $PolicyDefintion.policyDefinitionReferenceId
    #write-host "Azure Policy Id: " $PolicyDefintion.policyDefinitionReferenceId
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Azure Enforce Policy Name:" -Value ""
    #write-host "Azure Policy Name:" $Policy.Properties.DisplayName
    # Audit Description
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Azure Enforce Policy Description:" -Value ""
    #write-host "Azure Policy Description:" $Policy.Properties.Description
    # Audit Guid
    Add-Member -InputObject $object1 -MemberType NoteProperty -Name "Azure Enforce Policy Id" -Value ""

    $masterArray += $object1
}

$masterArray | convertTo-csv | Out-File "AuditCISGroup2Level2.csv"


###

Get-AzPolicyDefinition -Name "a06d0189-92e8-4dba-b0c4-08d7669fce7d"