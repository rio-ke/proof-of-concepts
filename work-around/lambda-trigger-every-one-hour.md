lambda-trigger-every-one-hour.md

```tf
data "aws_caller_identity" "account" {}

resource "aws_lambda_layer_version" "layer" {
  filename                 = "${path.module}/layers/datadog.zip"
  layer_name               = "datadog"
  compatible_runtimes      = ["python3.9"]
  compatible_architectures = ["x86_64"]
}

resource "aws_iam_role" "role" {
  name = "${var.SensitiveFileMonitorLambdaRole}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name = "${var.SensitiveFileMonitorLambdaRole}-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.account.account_id}:*"
      },
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.account.account_id}:log-group:/aws/lambda/${var.SensitiveFileMonitorLambdaRole}:*"]
      },
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = ["*"]
      },
      {
        Effect   = "Allow",
        Action   = "secretsmanager:ListSecrets",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        Resource = "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.account.account_id}:secret:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}


data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/lambdaHandlers/c6.py"
  output_path = "${path.module}/lambdaHandlers/c6.py.zip"
}

resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name    = var.SensitiveFileMonitorLambdaRole
  role             = aws_iam_role.role.arn
  handler          = "c6.lambda_handler"
  runtime          = "python3.9"
  layers           = [aws_lambda_layer_version.layer.arn]
  timeout          = var.lambdaTimeout
  environment {
    variables = {
      backetName = var.monitorBucketName
    }
  }
}

resource "aws_cloudwatch_event_rule" "rule" {
  name                = "${var.SensitiveFileMonitorLambdaRole}-event-rule"
  description         = "Everyday every one hour trigger"
  schedule_expression = "cron(0 */1 ? * * *)"
}

resource "aws_cloudwatch_event_target" "event" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "lambda"
  arn       = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "${var.SensitiveFileMonitorLambdaRole}InvokePermission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event.arn
}


variable "SensitiveFileMonitorLambdaRole" {}
variable "monitorBucketName" {}
variable "lambdaTimeout" {}
variable "region" {}


# https://docs.snowflake.com/en/user-guide/data-load-s3-config-aws-iam-role.html
```
