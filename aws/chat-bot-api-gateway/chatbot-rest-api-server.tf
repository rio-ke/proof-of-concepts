data "template_file" "user_data_chatbot_rest_api_server" {
  template = file("scripts/chatbot-rest-api-server-script.sh")
  vars = {
    efsvol = aws_efs_mount_target.private-subnet-1-efs.dns_name
  }
}

resource "aws_instance" "chatbot-rest-api-server" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.chatbot-rest-api-security-group.id]
  key_name               = var.key-name
  user_data              = data.template_file.user_data_chatbot_rest_api_server.rendered
  tags                   = merge(map("Name", "${var.project}-neo-server"), var.additional_tags)
  depends_on             = [aws_nat_gateway.nat, aws_efs_mount_target.private-subnet-1-efs, aws_efs_mount_target.private-subnet-2-efs]

}

# aws_security_group
resource "aws_security_group" "chatbot-rest-api-security-group" {
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
  tags   = merge(map("Name", "${var.project}-chatbot-rest-api-server-security-group"), var.additional_tags)
  name   = "${var.project}-chatbot-rest-api-server-security-group"
}

resource "aws_lb" "chat-api-lb" {
  name                       = "${var.project}-chatbot-rest-api-lb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  enable_deletion_protection = false
  tags                       = merge(map("Name", "${var.project}-chatbot-rest-api-server-lb"), var.additional_tags)
  depends_on                 = [aws_nat_gateway.nat]
}

resource "aws_lb_target_group" "chat-api-lb" {
  name       = "${var.project}-lb-chatbot-rest-api"
  port       = 80
  protocol   = "TCP"
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_nat_gateway.nat]
}

resource "aws_lb_listener" "chat-api-lb" {
  load_balancer_arn = aws_lb.chat-api-lb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.chat-api-lb.arn
  }
  depends_on = [aws_nat_gateway.nat]
}

resource "aws_lb_target_group_attachment" "chat-api-lb" {
  target_group_arn = aws_lb_target_group.chat-api-lb.arn
  target_id        = aws_instance.chatbot-rest-api-server.id
  port             = 80
  depends_on       = [aws_nat_gateway.nat]
}
