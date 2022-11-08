data "template_file" "scriptData" {
  template = file("scripts/main.sh")
  vars = {
    ssmParameterName = var.ssmParameterName
  }
}

resource "aws_iam_role" "er" {
  name = "${var.roleName}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each   = toset(local.awsManagedRoles)
  role       = aws_iam_role.er.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_iam_instance_profile" "aiip" {
  name = "${var.roleName}-ec2-role-profile"
  role = aws_iam_role.er.name
}


locals {
  awsManagedRoles = var.awsManagedRoles
}

resource "aws_instance" "neo-server" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.neo-security-group.id]
  key_name               = var.key-name
  tags                   = merge(map("Name", "${var.project}-neo-server"), var.additional_tags)

  user_data              = data.template_file.scriptData.rendered
  iam_instance_profile   = aws_iam_instance_profile.aiip.name
}


variable "ssmParameterName" {
    default = "ubuntu"
}

variable "roleName" {
  default = "dodo-instance"
}

variable "awsManagedRoles" {
  type        = list(string)
  default     = ["AmazonSSMFullAccess", "AmazonSSMManagedInstanceCore", "AmazonSSMPatchAssociation", "CloudWatchFullAccess"]
  description = "List of StringList(s)"
}
