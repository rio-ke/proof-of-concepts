aws apigateway with lambda function creation

Requirements

    * Terraform
    * aws access key
    * aws secret key

Runtime variables

      accessKey       = ""
      secretKey       = ""
      region          = "us-east-1"
      api-gateway-name= ""
      vpc_cidr        = "10.0.0.0/16"  # do not change
      project         = "duckduckgo"
      key-name        = "xps-add"

commands

    1. terraform version
    2. terraform init
    3. terraform plan -var-file=config.tfvars
    4. terraform apply -var-file=config.tfvars
    5. terraform destroy -var-file=config.tfvars
