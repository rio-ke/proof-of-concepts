#!/usr/bin/env bash
export AZDO_PERSONAL_ACCESS_TOKEN="<Personal Access Token>"
export AZDO_ORG_SERVICE_URL="https://dev.azure.com/<Your Org Name>"

terraform init
terraform plan -var-file=config.tfvars
terraform apply -var-file=config.tfvars

# if you want to destrot the resource you can enable the command or execute below commands
# terraform destroy -var-file=config.tfvars
