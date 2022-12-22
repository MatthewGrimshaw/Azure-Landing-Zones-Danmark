az login --tenant '4f8875af-ac0b-46ee-8a73-3634138f5818'


Push-Location
Set-Location .\terraform\modules\management_groups

# terrafrom init
terraform init

# terraform plan
terraform plan -out assignmnet.tfplan

#terraform apply
terraform apply assignmnet.tfplan

Pop-Location