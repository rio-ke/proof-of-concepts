terraform script for windows provision in aws


Requirements

Ubuntu

    $ wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
    $ unzip terraform_0.13.5_linux_amd64.zip
    $ sudo mv terraform /usr/local/bin

Reference: 
        
    https://www.terraform.io/downloads.html

variables:

    accessKey           =""
    secretKey           =""
    region              ="eu-west-1"
    instanceUsername    ="terraformuser"
    instancePassword    ="Password@123"
    instance_type       ="t2.micro"
    vpcNetworkAddress   ="10.0.0.0/16"
    subnetNetworkAddress="10.0.1.0/24"
    tagname             ="demo"
    keyname             ="windows-server"

commands

    1. Terraform version
    2. terraform init
    3. terraform plan -var-file=config.tfvars
    4. terraform apply -var-file=config.tfvars
    5. terraform destroy -var-file=config.tfvars
