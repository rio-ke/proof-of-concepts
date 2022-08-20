resource "aws_key_pair" "deployer" {
  key_name   = "${var.PROJECT}-${var.ENVIRONMENT}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDljY/Y83aWc2eRJP+Anwsio+IlHqqSD9sKqT9QBc6JDOKtltmh64DKWI9huVfhUwQtGkoMQnaWT+MUkI9J2DW30XhYOTpwRQtZKaGaJHomuGRNm2XXWdwTeWOG/aczDLCqRi/hU0yRkcHTAkZgCoGt1pB3NWqJv2huix5/t/ENkBNdeN0rhxPVzJVV/aht/G7L4YVf84aruc0oPoEOjTOxAWsatOQx61ZikmsB3VG6YtiPPjMjxt2ik7J/o5e0LVhbka0hrXXY/GW5+YrHBjCh8VmQxuXoCwoM8OEGspiQ8kpEP1++DKpUWBpq1euxAF22Td8sF06SRA4jHRWZy2POlwDBpHPUh8tqApfbt3j3zBcoZTMRzcxoP5DzLYOt/c3OrfUobcFyo60yOXbNPg9C2zcSOmb73KXtm6f42Mpq629rm3ICzd+eA0TwVfI3xzPuiAn6j0/aGOQpkv1Tsh+tJp9iha2RHK4UbJR0AKxUxrtl6YAxgEnYbycMODm6KZ0= dodo@dodo-xps-13-9360"
}


resource "aws_security_group" "allow_tls" {
  name        = "${var.PROJECT}-${var.ENVIRONMENT}-security-group"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.VPC_ID

  ingress {
    description = "TLS from VPC"
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

  tags = {
    Name = "${var.PROJECT}-security-group"
  }
}


resource "aws_instance" "web" {
  ami                    = var.AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = var.SUBNET_ID
  tags = {
    Name = "${var.PROJECT}-${var.ENVIRONMENT}-instance"
  }
}
