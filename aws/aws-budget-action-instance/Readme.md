terraform script for create budget action in aws

tools:

    1. terraform
    2. shell script

Instance tagname

    office-hours = ec-data-platform

Requirement Packages

    1. terraform
    2  Awscli

Ubuntu

    $ wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
    $ unzip terraform_0.13.5_linux_amd64.zip
    $ sudo mv terraform /usr/local/bin

    $ sudo apt install python3-pip -y
    $ pip3 install awscli (run as normal user)
    $ aws --version (make sure version)
      (aws-cli/1.18.183 Python/3.6.9 Linux/5.4.0-1029-aws botocore/1.19.23)

configure aws credentials

    $ aws configure

Reference:

    https://www.terraform.io/downloads.html

Alerts:

    60% trigger warning mail to customer
    70% trigger warning mail to customer
    80% trigger warning mail to customer
    90% trigger mail and stop the ec2 instance (Group  Mail)

    Note:

        90% mentioned in script.sh (default value)

variables:

    #accessKey     = ""
    #secretKey     = ""
    region        = "eu-west-1"
    budgetName    = "Ec2MonthlyBudgets"
    tagName       = "office-hours"
    tagValue      = "ec-data-platform"
    timeUnit      = "MONTHLY"
    limit_unit    = "USD"
    limit_amount  = "100"
    budget_type   = "COST"
    ActionSubType = "STOP_EC2_INSTANCES"
    time_period_start = "2020-11-01_00:00"
    time_period_end   = "2087-06-15_00:00"
    subscriber_email_addresses = ["jinojoe@gmail.com","jjino@gmail.com"]
    group_email_address = "jinojoe@gmail.com"
    limits              = [ 60, 70, 80]

commands

    1. terraform version
    2. terraform init
    3. terraform plan    -var-file=6-config.tfvars
    4. terraform apply   -var-file=6-config.tfvars
    5. terraform destroy -var-file=6-config.tfvars

Reference

    # aws budgets create-budget --account-id 1234567891234 --budget 'BudgetName=costaBudget,BudgetLimit={Amount=500,Unit=USD},TimeUnit=MONTHLY,BudgetType=COST'

    # aws budgets create-budget-action --account-id 1234567891234 --budget-name costaBudget --notification-type ACTUAL --action-type RUN_SSM_DOCUMENTS --action-threshold ActionThresholdValue=80,ActionThresholdType=PERCENTAGE --definition "SsmActionDefinition={ActionSubType=STOP_EC2_INSTANCES,Region=us-east-1,InstanceIds=[i-06381489d20000000,i-0e629146500000000]}" --execution-role-arn arn:aws:iam::1234567891234:role/MyBudgetRole --approval-model AUTOMATIC --subscribers SubscriptionType=EMAIL,Address=costa@costaemails.com

    # https://docs.aws.amazon.com/cli/latest/reference/budgets/create-budget-action.html


