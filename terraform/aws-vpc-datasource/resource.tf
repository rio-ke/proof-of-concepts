resource "aws_subnet" "main" {
  vpc_id     = data.aws_vpc.av.id
  cidr_block = "172.31.112.0/20"
  tags = {
    Name = "${var.PROJECT}-${var.ENVIRONMENT}-subnet"
  }
}

resource "aws_iam_role" "air_lambda" {
  name               = "${var.PROJECT}-${var.ENVIRONMENT}-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}



resource "aws_iam_policy" "policy" {
  name        = "${var.PROJECT}-${var.ENVIRONMENT}-lambda-policy"
  description = "Lambda will consume this policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "adminPrivilegesGrantsPolicy",
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "aipa" {
  name       = "${var.PROJECT}-${var.ENVIRONMENT}-lambda-policy"
  roles      = [aws_iam_role.air_lambda.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "test_lambda" {
    function_name                  = "${var.PROJECT}-${var.ENVIRONMENT}-lambda"
    handler                        = "index.handler"
    package_type                   = "Zip"
    role                           = "aws_iam_role.air_lambda.arn"
    runtime                        = "nodejs14.x"
}
