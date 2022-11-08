data "template_file" "scriptData" {
  template = file("scripts/main.sh")
  vars = {
    ssmParameterName = var.ssmParameterName
  }
}


resource "aws_instance" "neo-server" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.neo-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_file.scriptData.rendered
  tags                   = merge(map("Name", "${var.project}-neo-server"), var.additional_tags)

}

variable "ssmParameterName" {
    default = "ubuntu"
}
