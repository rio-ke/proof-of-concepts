data "template_file" "user_data_graph_server" {
  template = file("scripts/graph-server-script.sh")
    vars = {
    efsvol = aws_efs_mount_target.private-subnet-1-efs.dns_name
  }
}


resource "aws_launch_configuration" "launchconfiguration" {
  name_prefix     = "${var.project}-graph-server-launch-conf"
  image_id        = var.amis[var.region]
  instance_type   = "t2.micro"
  key_name        = var.key-name
  security_groups = [aws_security_group.auto_scale_instance.id]
  user_data       = data.template_file.user_data_graph_server.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling" {
  name                      = "${var.project}-graph-server-autoscaling"
  vpc_zone_identifier       = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  launch_configuration      = aws_launch_configuration.launchconfiguration.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "graph-server"
    propagate_at_launch = true
  }
  depends_on = [aws_nat_gateway.nat]
}


resource "aws_elb" "elb" {
  name            = "${var.project}-graph-server-elb"
  subnets         = [aws_subnet.public-subnet.id, aws_subnet.public-subnet-1.id]
  security_groups = [aws_security_group.elb-securitygroup.id]
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
  tags                        = merge(map("Name", "${var.project}-graph-server-elb"), var.additional_tags)
  depends_on                  = [aws_nat_gateway.nat]
}

resource "aws_security_group" "auto_scale_instance" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.project}-graph-server"
  description = "security group for my instance"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb-securitygroup.id]
  }
  tags = merge(map("Name", "${var.project}-graph-server"), var.additional_tags)

}

resource "aws_security_group" "elb-securitygroup" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.project}-elb-security-group"
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(map("Name", "${var.project}-elb-security-group"), var.additional_tags)
  depends_on             = [aws_nat_gateway.nat]

}
