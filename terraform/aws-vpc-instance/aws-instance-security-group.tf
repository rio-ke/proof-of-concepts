resource "aws_security_group" "asg" {
  name        = "${var.PROJECT}-${var.ENVIRONMENT}-asg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.av.id

  ingress {
    description = "TLS from SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from WEBSERVER"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from WEBSERVER"
    from_port   = 8080
    to_port     = 8080
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

  depends_on = [
    aws_key_pair.akp
  ]
}
