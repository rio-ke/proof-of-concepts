data "template_file" "user_data" {
  template = file("scripts/script.sh")
}

resource "aws_instance" "neo-1" {
  ami                    = var.amis[var.region]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.neo-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_file.user_data.rendered
  tags = {
    Name = "${var.project}-neo-server-1"
  }
}

resource "aws_instance" "neo-2" {
  ami                    = var.amis[var.region]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-2.id
  vpc_security_group_ids = [aws_default_security_group.neo-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_file.user_data.rendered
  tags = {
    Name = "${var.project}-neo-server-2"
  }
}

# aws_security_group
resource "aws_default_security_group" "neo-security-group" {
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
    Name = "${var.project}-neo-security-group"
  }
}
