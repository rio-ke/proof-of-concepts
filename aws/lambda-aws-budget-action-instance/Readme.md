terraform script for create lambda budget action in aws

tools:

    1. terraform

Instance tagname

    office-hours = ec-data-platform

Requirement Packages

    1. terraform

Ubuntu

    $ wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
    $ unzip terraform_0.13.5_linux_amd64.zip
    $ sudo mv terraform /usr/local/bin


Reference:

    https://www.terraform.io/downloads.html

Alerts:

    80%  Actual
    90%  Actual
    100% Forecasting
    100% Actual


variables:

    #accessKey     = ""
    #secretKey     = ""
    region         = "eu-west-1"
    lambdaname     = "lambda-aws-budget-action"
    budgetName     = "demobudgets"
    tagName        = "office-hours"
    tagValue       = "ec-data-platform"

commands

    1. terraform version
    2. terraform init
    3. terraform plan    -var-file=5-config.tfvars
    4. terraform apply   -var-file=5-config.tfvars
    5. terraform destroy -var-file=5-config.tfvars

Cron timing:

    every day - 00:00



Reference:

    https://stackoverflow.com/questions/53736963/aws-lambda-console-upgrade-boto3-version
