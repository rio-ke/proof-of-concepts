_provider_

```tf
provider "aws" {
  region = "ap-southeast-1"
}
```

_instance creation_

```tf
resource "aws_instance" "traneconnect-service-1" {
  for_each = {for k, v in var.traneconnect_service_list : k => v if (contains(v.segments, 1) && var.traneconnect_remove_service != k)}

  instance_type = each.value.instance_type
  ami = "ami-07651f0c4c315a529"
  tags = {
    Name = "traneconnect-${each.key}"
  }
  vpc_security_group_ids = [
    "sg-0c99085f74912d1fe"
  ]
  subnet_id = "subnet-01ea1a2a4e35f21d9"
  key_name = "pcs"
}
```

_alaram creation_

```tf
resource "aws_cloudwatch_metric_alarm" "ec2Cpu" {
  for_each = {for k, v in var.traneconnect_service_list : k => v if (contains(v.segments, 1) && var.traneconnect_remove_service != k)}
  alarm_name                = "traneconnect-${each.key}-cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors -traneconnect-${each.key}-1"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = aws_instance.traneconnect-service-1[each.key].id
  }
  alarm_actions    = ["arn:aws:sns:ap-southeast-1:xxx:eb-sns-test"]
}
```

_rule creation_

```tf
resource "aws_cloudwatch_event_rule" "rule" {
  event_bus_name = "default"
  event_pattern  = jsonencode({
      detail      = {
          instance-id = [ for v in aws_instance.traneconnect-service-1 :  v.id ]
          state       = ["terminated","stopped"]
      }
      detail-type = ["EC2 Instance State-change Notification"]
      source      = ["aws.ec2",]
  })
  is_enabled     = true
  name           = "-traneconnect-1--event-rule-mon-status"
}

variable "traneconnect_remove_service" {
  default = ""
}

variable "traneconnect_service_list" {
  default = {
    "gateway" = {
      instance_type = "t2.small"
      ip_start      = 51
      segments      = [1, 2]
      aws_credentials = false
    }

    "gridflex-apollo" = {
      instance_type = "t2.small"
      ip_start      = 61
      segments      = [1, 2]
      aws_credentials = false
    }
}
}
```
