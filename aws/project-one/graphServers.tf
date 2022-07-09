resource "aws_instance" "graph-server-1" {
  ami                    = var.amis[var.region]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_security_group.graph-server-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_cloudinit_config.cloudinit-neo-server.rendered
  tags = {
    Name = "${var.project}-graph-server-1"
  }
}

resource "aws_instance" "graph-server-2" {
  ami                    = var.amis[var.region]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-2.id
  vpc_security_group_ids = [aws_security_group.graph-server-security-group.id]
  user_data              = data.template_cloudinit_config.cloudinit-neo-server.rendered
  key_name               = var.key-name
  tags = {
    Name = "${var.project}-graph-server-2"
  }
}

resource "aws_security_group" "graph-server-security-group" {
  name        = "${var.project}-graph-server-security-group"
  description = "graph-server-security-group"
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-graph-server-security-group"
  }
}
