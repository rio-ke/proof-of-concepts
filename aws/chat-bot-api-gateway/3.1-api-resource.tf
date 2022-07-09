resource "aws_api_gateway_vpc_link" "vpclink" {
  name        = "${var.project}-vpc-link"
  description = "neo4j server apigateway"
  target_arns = [aws_lb.lb.arn]
}

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
  depends_on          = [aws_api_gateway_vpc_link.vpclink]
}



resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.project}-api"
  description = "neo4j and graph server apis"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  depends_on          = [aws_api_gateway_vpc_link.vpclink]

}


resource "aws_cloudwatch_log_group" "cloudwatch_log" {
  name = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/prod"
  # depends_on = [aws_api_gateway_rest_api.api]

}

resource "aws_iam_role" "cloudwatch" {
  name               = "${var.project}-api-cloudwatch"
  # depends_on = [aws_api_gateway_rest_api.api, aws_cloudwatch_log_group.cloudwatch_log ]
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
  name = "${var.project}-api-cloudwatch-policy"
  role = aws_iam_role.cloudwatch.id
  # depends_on = [aws_iam_role.cloudwatch]
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
