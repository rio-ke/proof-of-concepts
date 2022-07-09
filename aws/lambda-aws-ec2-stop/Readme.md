Requirements

    To stop ec2 instance use lambda function

Instance tagname format

        Name = demo

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
    lambdaname          ="lambda-aws-ec2-stop"
    tagName             ="office-hours"
    tagValue            ="ec-data-platform"

commands

    1. terraform version
    2. terraform init
    3. terraform plan -var-file=5-variable.tfvars
    4. terraform apply -var-file=5-variable.tfvars
    5. terraform destroy -var-file=5-variable.tfvars
