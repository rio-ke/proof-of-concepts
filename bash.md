```tf
provider "aws" {
    region = "us-east-1"
}


resource "aws_cloudwatch_metric_alarm" "test" {}


# terraform init
# terraform import aws_cloudwatch_metric_alarm.test alarm-12345
# terraform show
```
