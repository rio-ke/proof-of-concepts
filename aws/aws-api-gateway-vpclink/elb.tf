#resource "aws_elb" "elb" {
#  name            = "${var.project}-elb"
#  subnets         = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id, aws_subnet.subnet-3.id]
#  security_groups = [aws_default_security_group.neo-security-group.id]
#  internal           = true
#  
#  listener {
#    instance_port     = 8080
#    instance_protocol = "http"
#    lb_port           = 80
#    lb_protocol       = "http"
#  }
#  health_check {
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#    timeout             = 3
#    target              = "HTTP:8080/"
#    interval            = 30
#  }
#
#  cross_zone_load_balancing   = true
#  connection_draining         = true
#  connection_draining_timeout = 400
#  tags = {
#    Name = "${var.project}-elb"
#  }
#}
#
#resource "aws_elb_attachment" "node-1" {
#  elb      = aws_elb.elb.id
#  instance = aws_instance.neo-1.id
#}
#
#resource "aws_elb_attachment" "node-2" {
#  elb      = aws_elb.elb.id
#  instance = aws_instance.neo-2.id
#}

resource "aws_lb" "lb" {
  name               = "${var.project}-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.subnet-3.id, aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  enable_deletion_protection = false
  tags = {
    Name = "${var.project}-lb"
  }
}

resource "aws_lb_target_group" "lb" {
  name     = "${var.project}-lb-target-group"
  port     = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.lb.arn
  target_id        = aws_instance.neo-1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "test-1" {
  target_group_arn = aws_lb_target_group.lb.arn
  target_id        = aws_instance.neo-2.id
  port             = 8080
}