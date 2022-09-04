```tf
resource "aws_sns_topic" "ast" {
  name = var.topicName
}

resource "aws_sns_topic_subscription" "asts" {
  for_each  = toset(local.subscriptionEmailLists)
  topic_arn = aws_sns_topic.ast.arn
  protocol  = "email"
  endpoint  = each.value
}

locals {
  subscriptionEmailLists = var.emailList
  instanceIdLists        = var.instanceIds
}

resource "aws_cloudwatch_metric_alarm" "ec2cpu" {
  for_each                  = toset(local.instanceIdLists)
  alarm_name                = "${each.value}-cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "ec2CPUUtilization"
  namespace                 = "CWAgent"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ${each.value} ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = each.value
  }
  alarm_actions = [aws_sns_topic.ast.arn]
  ok_actions    = [aws_sns_topic.ast.arn]
}



variable "topicName" {
    default = "dodo-topic"
}

variable "emailList" {
  type        = list(string)
  default     = ["jinojoe@gmail.com"]
  description = "List of StringList(s)"
}

variable "instanceIds" {
  type        = list(string)
  default     = ["xxx"]
  description = "List of StringList(s)"
}


```
