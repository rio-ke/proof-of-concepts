commands

```bash
mkdir ado-variable-group-creation
cd ado-variable-group-creation

# create all files with appropriate extentions
export AZDO_PERSONAL_ACCESS_TOKEN=<Personal Access Token>
export AZDO_ORG_SERVICE_URL=https://dev.azure.com/<Your Org Name>

terraform init

# change the params under config.tfvars file
terraform apply -var-file=config.tfvars
```

![image](https://user-images.githubusercontent.com/57703276/187509227-8cde6495-1d06-4c8f-89e1-b6ec74f9737e.png)
