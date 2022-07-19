**EC2 instance CPu 80% utilization alarm to SNS**

```tf
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name                = "ec2-cpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "ec2CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = "i-06858e6449749f729"
  }
  alarm_actions = ["arn:aws:sns:ap-south-1:399946845918:notify"]
  ok_actions    = ["arn:aws:sns:ap-south-1:399946845918:notify"]
}

```

**RDS instance CPu 80% utilization alarm to SNS**

```tf
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name                = "rds-southcpu-utilization"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "rdsCPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = "database-1"
  }
  alarm_actions = ["arn:aws:sns:ap-south-1:399946845918:notify"]
  ok_actions    = ["arn:aws:sns:ap-south-1:399946845918:notify"]
}

```

<!-- https://github.com/lorenzoaiello/terraform-aws-rds-alarms/blob/master/main.tf -->
