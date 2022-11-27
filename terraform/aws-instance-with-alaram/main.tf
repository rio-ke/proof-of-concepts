module "instanceCreation" {
  source                       = "./module/aws-instance-with-alaram"
  creationOfIamInstanceProfile = true
  roleName                     = "ssm-and-cloud-instance"
  ssmParameterName             = "Amazoncloudwatch-linux"
  instancesDetails = {
    one = {
      ami                    = "ami-0af2f764c580cc1f9"
      instance_type          = "t2.micro"
      subnet_id              = "subnet-01ea1a2a4e35f21d9"
      vpc_security_group_ids = ["sg-0c99085f74912d1fe"]
      key_name               = "demo"
    },
    two = {
      ami                    = "ami-0af2f764c580cc1f9"
      instance_type          = "t2.micro"
      subnet_id              = "subnet-01ea1a2a4e35f21d9"
      vpc_security_group_ids = ["sg-0c99085f74912d1fe"]
      key_name               = "demo"
    }
  }
  alarm_actions    = ["arn:aws:sns:ap-southeast-1:676487226531:demo"]
  alarm_ok_actions = ["arn:aws:sns:ap-southeast-1:676487226531:demo"]
}
