data "template_file" "user_data_neo_server" {
  template = file("scripts/neo-server-script.sh")
  vars = {
    efsvol = aws_efs_mount_target.private-subnet-1-efs.dns_name
  }
}

resource "aws_instance" "neo-server" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.neo-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_file.user_data_neo_server.rendered
  tags                   = merge(map("Name", "${var.project}-neo-server"), var.additional_tags)
  depends_on             = [aws_nat_gateway.nat, aws_efs_mount_target.private-subnet-1-efs, aws_efs_mount_target.private-subnet-2-efs]

}

# aws_security_group
resource "aws_security_group" "neo-security-group" {
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    description = "neo-server-nfs-rule"

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id
  tags   = merge(map("Name", "${var.project}-neo-server-security-group"), var.additional_tags)

}

resource "aws_lb" "lb" {
  name                       = "${var.project}-neo-lb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  enable_deletion_protection = false
  tags                       = merge(map("Name", "${var.project}-neo-server-lb"), var.additional_tags)
  depends_on                 = [aws_nat_gateway.nat]
}

resource "aws_lb_target_group" "lb" {
  name       = "${var.project}-lb-neo-target-group"
  port       = 8080
  protocol   = "TCP"
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_nat_gateway.nat]
}

resource "aws_lb_listener" "graph-lb" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }
  depends_on = [aws_nat_gateway.nat]
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.lb.arn
  target_id        = aws_instance.neo-server.id
  port             = 8080
  depends_on       = [aws_nat_gateway.nat]
}
