az login --tenant '4f8875af-ac0b-46ee-8a73-3634138f5818'

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


azurerm_log_analytics_solution
azurerm_log_analytics_solution