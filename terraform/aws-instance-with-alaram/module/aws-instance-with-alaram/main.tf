data "template_file" "scriptData" {
  template = file("${path.module}/scripts/main.sh")
  vars = {
    ssmParameterName = var.ssmParameterName
  }
}

resource "aws_instance" "instance" {
  for_each               = var.instancesDetails
  ami                    = lookup(each.value, "ami", "ami-0af2f764c580cc1f9")
  instance_type          = lookup(each.value, "instance_type", "t2.micro")
  subnet_id              = lookup(each.value, "subnet_id", "subnet-01ea1a2a4e35f21d9")
  vpc_security_group_ids = lookup(each.value, "vpc_security_group_ids", ["sg-0c99085f74912d1fe"])
  key_name               = lookup(each.value, "key_name", "demo")
  iam_instance_profile   = lookup(each.value, "iam_instance_profile", local.iam_instance_profile)
  user_data              = data.template_file.scriptData.rendered
  tags                   = merge({ Name = each.key }, tomap(lookup(each.value, "tags", local.tags)))
}

resource "aws_cloudwatch_metric_alarm" "ec2Cpu" {
  for_each                  = var.instancesDetails
  alarm_name                = "${each.key}-cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ${each.key} ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = aws_instance.instance[each.key].id
  }
  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_ok_actions
}


resource "aws_cloudwatch_metric_alarm" "ec2memory" {
  for_each                  = var.instancesDetails
  alarm_name                = "${each.key}-memory-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "This metric monitors ${each.key} ec2 memory utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = aws_instance.instance[each.key].id
  }
  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_ok_actions
}

resource "aws_cloudwatch_event_rule" "rule" {
    for_each       = var.instancesDetails
    event_bus_name = "default"
    event_pattern  = jsonencode({
        detail      = {
            instance-id = [aws_instance.instance[each.key].id]
            state       = ["terminated","stopped"]
        }
        detail-type = ["EC2 Instance State-change Notification"]
        source      = ["aws.ec2",]
    })
    is_enabled     = true
    name           = "${each.key}-event-rule-mon-status"
    tags           = merge({ Name = each.key }, tomap(lookup(each.value, "tags", local.tags)))
}
