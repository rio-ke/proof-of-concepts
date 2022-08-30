## aws-cloud-watch-agent-for-windows.md

```ps1
$url = "https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip"
$output = $env:TEMP + "\AmazonCloudWatchAgent.zip"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
Expand-Archive -path $output -destinationpath $env:TEMP
cd $env:TEMP
./install.ps1
Set-Location -Path 'C:\Program Files\Amazon\AmazonCloudWatchAgent'
./amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-windows -s
```


```tf
resource "aws_iam_policy" "ep" {
  name        = "${var.roleName}-policy"
  path        = "/"
  description = "Policy to provide permission to EC2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:Describe*",
          "cloudwatch:*",
          "logs:*",
          "sns:*",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "cloudwatch:PutMetricData",
          "ds:CreateComputer",
          "ds:DescribeDirectories",
          "ec2:DescribeInstanceStatus",
          "logs:*",
          "ssm:*",
          "ec2messages:*",
          "ssm:*",
          "tag:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "er" {
  name = "${var.roleName}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "epr" {
  name       = "${var.roleName}-role-attachment"
  roles      = [aws_iam_role.er.name]
  policy_arn = aws_iam_policy.ep.arn
}

resource "aws_iam_instance_profile" "aiip" {
  name = "${var.roleName}-ec2-role-profile"
  role = aws_iam_role.er.name
}


variable "roleName" {
  default = "instance"
}

```
