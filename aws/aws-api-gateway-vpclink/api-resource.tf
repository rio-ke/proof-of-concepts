resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api-gateway-name}-api"
  description = "This is my API for demonstration purposes"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_vpc_link" "example" {
  name        = "${var.project}-vpc-link"
  description = "example description"
  target_arns = [aws_lb.lb.arn]
}

resource "aws_cloudwatch_log_group" "yada" {
  name = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/prod"
}

resource "aws_iam_role" "cloudwatch" {
  name               = "${var.api-gateway-name}-cloudwatch"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "${var.api-gateway-name}-cloudwatch-policy"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
