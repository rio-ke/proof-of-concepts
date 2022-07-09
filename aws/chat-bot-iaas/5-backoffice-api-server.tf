data "template_file" "user_data_backend_office_api_server" {
  template = file("scripts/backend-office-api-server-script.sh")
  vars = {
    efsvol = aws_efs_mount_target.private-subnet-1-efs.dns_name
  }
}

resource "aws_instance" "backend-office-api-server" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.backend-office-api-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_file.user_data_backend_office_api_server.rendered
  tags                   = merge(map("Name", "${var.project}-backend-office-api-server"), var.additional_tags)
  depends_on             = [aws_nat_gateway.nat, aws_efs_mount_target.private-subnet-1-efs]
}

# aws_security_group

resource "aws_security_group" "backend-office-api-security-group" {

  ingress {
    description = "backend-office-api-ssh-security-rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "backend-office-api-http-security-rule"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    description = "backend-office-api-outgoing-security-rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id     = aws_vpc.vpc.id
  name       = "backend-office-api-security-group"
  tags       = merge(map("Name", "${var.project}-backend-office-api-server-security-group"), var.additional_tags)
  depends_on = [aws_nat_gateway.nat]
}


resource "aws_elb" "elb-api" {
  name            = "${var.project}-backend-office-api-elb"
  subnets         = [aws_subnet.public-subnet.id, aws_subnet.public-subnet-1.id]
  security_groups = [aws_security_group.backend-office-api-security-group-elb.id]
  internal        = true

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  tags                        = merge(map("Name", "${var.project}-gbackend-office-api-server-elb"), var.additional_tags)
  depends_on                  = [aws_nat_gateway.nat]
}

resource "aws_elb_attachment" "backend-office-api-server" {
  elb        = aws_elb.elb-api.id
  instance   = aws_instance.backend-office-api-server.id
  depends_on = [aws_elb.elb-api]

}


resource "aws_security_group" "backend-office-api-security-group-elb" {
  vpc_id = aws_vpc.vpc.id
  name   = "elb-backend-office-api-security-group"
  ingress {
    description = "backend-office-api-https-security-rule"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description = "backend-office-api-http-security-rule"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    description = "backend-office-api-outgoing-security-rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags       = merge(map("Name", "${var.project}-backend-office-api-server-security-group-elb"), var.additional_tags)
  depends_on = [aws_nat_gateway.nat]
}
