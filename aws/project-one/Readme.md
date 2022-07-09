aws apigateway with lambda function creation

Requirements

    * Terraform
    * aws access key
    * aws secret key

Runtime variables

    accessKey=""
    secretKey=""
    region=""


commands

    1. terraform version
    2. terraform init
    3. terraform plan -var-file=config.tfvars
    4. terraform apply -var-file=config.tfvars
    5. terraform destroy -var-file=config.tfvars