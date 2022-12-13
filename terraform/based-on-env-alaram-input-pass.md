


```tf
data "aws_caller_identity" "account_id" {}

locals {
  alarm_actions = var.env == "prod" ? ["arn:aws:sns:us-east-1:${data.aws_caller_identity.account_id.account_id}:${var.env}-alarm-topic"] : (var.env == "stg" ? ["arn:aws:sns:us-east-1:${data.aws_caller_identity.account_id.account_id}:${var.env}-alarm-topic"] :  ["arn:aws:sns:us-east-1:${data.aws_caller_identity.account_id.account_id}:${var.env}-alarm-topic"])
}

module "instanceCreation" {
  source                       = "./module/aws-instance-with-alaram"
  creationOfIamInstanceProfile = false
  roleName                     = data.aws_iam_instance_profile.profile.role_name
  ssmParameterName             = "Amazoncloudwatch-linux"
  instancesDetails = {
    tcc-tisexport-1 = {
      ami                    = data.aws_ami.ami.id
      instance_type          = "t2.medium"
      subnet_id              = "subnet-01ea1a2a4e35f21d9"
      vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
      key_name               = "${var.env}-${var.region}-kp"
      private_ip             = var.tcc_tisexport_1_ip
      iam_instance_profile   = data.aws_iam_instance_profile.profile.name
      tags = {
           Name = "${var.env}-${var.region}-tcc-tisexport-1-${var.primary_availability_zone}"
         }
    }
  }
  alarm_actions    = local.alarm_actions
  alarm_ok_actions = local.alarm_actions
}
```
