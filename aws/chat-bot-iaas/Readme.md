resource details

| resources | count | 
| --------------- | --------------- | 
| vpc | 1 | 
| private subnet  | 2 | 
| public subnet | 2 |
| nat gateway | 1 | 
| efs volume | 1 | 
| lambda | 2 | 
| elb | 1 |
| nlb | 1 |
| mongodb server | 1 | 
| graph server | min 1 max 2 | 
| neo4j server | 1 | 
| auto scalling | 1 | 


Runtime variables

| variable name | value | require |
| --------------- | --------------- | --------------- | 
| accessKey | xxxxxxxxxxxx |  yes |
| secretKey | xxxxxxxxxxxx |  yes |
| region | eu-west-1 |  yes |
| project | chat-bot |  yes |
| key-name | chat-key |  yes |
| instance_type | t2.micro |  yes |
| vpc_cidr | 10.0.0.0/16 |  yes |
| public_subnet | 10.0.1.0/24 |  yes |
| public-subnet-1 | 10.0.2.0/24 |  yes |
| private_subnet_1 | 10.0.3.0/24 |  yes |
| private_subnet_2 | 10.0.4.0/24 |  yes |
| tagName | office-hours |  yes |
| tagValue | ec-data-platform |  yes |


commands

    1. terraform version
    2. terraform init
    3. terraform plan -var-file=config.tfvars
    4. terraform apply -var-file=config.tfvars
    5. terraform destroy -var-file=config.tfvars