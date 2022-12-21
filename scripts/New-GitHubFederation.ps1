<#
        .SYNOPSIS
        Creates a federated identity credential between Azure Active Directory and GitHub that can be used to run Github actions.

        .DESCRIPTION
        Creates a federated identity credential between Azure Active Directory and GitHub that can be used to run Github actions.
        This is the prefered approach as there are no secrets or keys to secure or rotate.
        See the following documents for more details:
        https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-powershell%2Cwindows#use-the-azure-login-action-with-openid-connect

        .EXAMPLE
        PS> New-GithubFerderation.ps1

        .EXAMPLE
        PS> New-GithubFerderation.ps1
#>

param (
    [String]
    $appName = "Matthew-Danmark-ALZ",
    $repo = "MatthewGrimshaw/Azure-Landing-Zones-Danmark"
)

Connect-AzAccount -Tenant '4f8875af-ac0b-46ee-8a73-3634138f5818'

Install-Module -Name PowerShellGet -Scope CurrentUser -AllowClobber -Force
Install-Module -Name Az.Resources -AllowPrerelease -Scope CurrentUser -Force

# create the Azure AD application that will be used for federation
New-AzADApplication -DisplayName $appName


#Create a service principal using the appid from the Azure AD Application
$clientId = (Get-AzADApplication -DisplayName $appName).AppId
New-AzADServicePrincipal -ApplicationId $clientId

# create a federated identity credential on an app
$objectId = (Get-AzADApplication -DisplayName $appName).Id
New-AzADAppFederatedCredential -ApplicationObjectId $objectId -Audience api://AzureADTokenExchange -Issuer 'https://token.actions.githubusercontent.com' -Name "$appName-Production" -Subject "repo:$($repo):environment:Production"
New-AzADAppFederatedCredential -ApplicationObjectId $objectId -Audience api://AzureADTokenExchange -Issuer 'https://token.actions.githubusercontent.com' -Name "$appName-Canary" -Subject "repo:$($repo):environment:Canary"
New-AzADAppFederatedCredential -ApplicationObjectId $objectId -Audience api://AzureADTokenExchange -Issuer 'https://token.actions.githubusercontent.com' -Name "$appName-PR" -Subject "repo:$($repo):pull_request"
New-AzADAppFederatedCredential -ApplicationObjectId $objectId -Audience api://AzureADTokenExchange -Issuer 'https://token.actions.githubusercontent.com' -Name "$appName-Main" -Subject "repo:$($repo):ref:refs/heads/main"


# create a new role assignmnet - the service principal needs root contributor in order to be able to create the Management Group structure
$objectId = (Get-AzADServicePrincipal -DisplayName $appName).Id
New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName Contributor -Scope /


#Get the values for clientId, subscriptionId, and tenantId to use later in your GitHub Actions workflow.
$clientId = (Get-AzADApplication -DisplayName $appName).AppId
$subscriptionId = (Get-AzContext).Subscription.Id
$tenantId = (Get-AzContext).Subscription.TenantId

write-output "For GitHib secrets use:"
write-output "clientID: "           $clientId
write-output "subscriptionId: "     $subscriptionId
write-output "tenantId: "           $tenantId

##TERRAFORM## - needs an if statement

$RESOURCE_GROUP_NAME='Management'
$STORAGE_ACCOUNT_NAME="mgmtstorageqwerty"
$CONTAINER_NAME='tfstate'
$location = 'westeurope'

# Create resource group
New-AzResourceGroup -Name $RESOURCE_GROUP_NAME -Location $location

# Create storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME -SkuName Standard_LRS -Location $location -AllowBlobPublicAccess $true -EnableHttpsTrafficOnly $true

$storageAccount = Get-AzStorageAccount -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME

# Create blob container
New-AzStorageContainer -Name $CONTAINER_NAME -Context $storageAccount.context -Permission blob

$ACCOUNT_KEY=(Get-AzStorageAccountKey -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME)[0].value


write-output "For Terraform GitHib secrets use:"
write-output "resource_group_name: "            $resource_group_name
write-output "storage_account_name: "           $STORAGE_ACCOUNT_NAME
write-output "container_name: "                 $CONTAINER_NAME
write-output "key: "                            $ACCOUNT_KEY


###TODO: Create GitHub Environments and Secrets