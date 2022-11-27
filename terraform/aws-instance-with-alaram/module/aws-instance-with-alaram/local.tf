locals {
  tags                 = var.tags == {} ? {} : var.tags
  iam_instance_profile = var.creationOfIamInstanceProfile == false ? "" : aws_iam_instance_profile.aiip[0].name
}
