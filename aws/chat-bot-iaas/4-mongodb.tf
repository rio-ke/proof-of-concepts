data "template_file" "user_data_mongodb_server" {
  template = file("scripts/mongodb-server-script.sh")
  vars = {
    efsvol = aws_efs_mount_target.private-subnet-1-efs.dns_name
  }
}

resource "aws_instance" "mongodb-server" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.mongodb-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_file.user_data_mongodb_server.rendered
  tags                   = merge(map("Name", "${var.project}-mongodb-server"), var.additional_tags)
  depends_on             = [aws_nat_gateway.nat, aws_efs_mount_target.private-subnet-1-efs]
}

# aws_security_group
resource "aws_security_group" "mongodb-security-group" {
  ingress {
    description = "mongo-security-group"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "mongodb-security-group"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id     = aws_vpc.vpc.id
  name       = "mongodb-server-security-group"
  tags       = merge(map("Name", "${var.project}-mongodb-server-security-group"), var.additional_tags)
  depends_on = [aws_nat_gateway.nat]
}
