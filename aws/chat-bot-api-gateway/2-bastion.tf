resource "aws_eip" "lb" {
  instance = aws_instance.bastion.id
  vpc      = true
}

resource "aws_instance" "bastion" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.bastion-security-group.id]
  key_name               = var.key-name
  tags                   = merge(map("Name", "${var.project}-bastion-server"), var.additional_tags)
}

resource "aws_security_group" "bastion-security-group" {
  ingress {
    description = "bastion-security-group"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id     = aws_vpc.vpc.id
  tags       = merge(map("Name", "${var.project}-bastion-server-security-group"), var.additional_tags)
  depends_on = [aws_nat_gateway.nat]
}