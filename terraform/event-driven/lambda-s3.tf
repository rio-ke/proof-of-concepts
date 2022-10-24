resource "aws_iam_role" "c2" {
  name = "${var.stageThreeLambdaOne}-role"
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

resource "aws_iam_policy" "c2" {
  name = "${var.stageThreeLambdaOne}-role-policy"
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
        Resource = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.account.account_id}:log-group:/aws/lambda/${var.stageThreeLambdaOne}:*"]
      },
      {
        Action   = ["sns:Publish"]
        Effect   = "Allow"
        Resource = ["${aws_sns_topic.c3.arn}"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "c2" {
  role       = aws_iam_role.a2.name
  policy_arn = aws_iam_policy.a2.arn
}

data "archive_file" "c2" {
  type        = "zip"
  source_file = "${path.module}/lambdaHandlers/c2.py"
  output_path = "${path.module}/lambdaHandlers/c2.py.zip"
}

resource "aws_lambda_function" "c2" {
  filename         = data.archive_file.c2.output_path
  source_code_hash = data.archive_file.c2.output_base64sha256
  function_name    = var.stageThreeLambdaOne
  role             = aws_iam_role.c2.arn
  handler          = "c2.lambda_handler"
  runtime          = "python3.9"
  layers           = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  timeout          = var.lambdaTimeout
  environment {
    variables = {
      snsArn = aws_sns_topic.c3.arn
    }
  }
}

data "archive_file" "c6" {
  type        = "zip"
  source_file = "${path.module}/lambdaHandlers/c6.py"
  output_path = "${path.module}/lambdaHandlers/c6.py.zip"
}

resource "aws_lambda_function" "c6" {
  filename         = data.archive_file.c6.output_path
  source_code_hash = data.archive_file.c6.output_base64sha256
  function_name    = var.stageThreeLambdaTwo
  role             = aws_iam_role.common.arn
  handler          = "c6.lambda_handler"
  runtime          = "python3.9"
  layers           = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  timeout          = var.lambdaTimeout
  environment {
    variables = {
      apiGatewayUrl       = aws_api_gateway_stage.get.invoke_url
      sqsUrl              = aws_sqs_queue.c4.url
      apiGatewayId        = aws_api_gateway_rest_api.api.id
      originBucketName    = data.aws_s3_bucket.c1.id
      success_bucket_name = data.aws_s3_bucket.d1.id
      failed_bucket_name  = data.aws_s3_bucket.d2.id
      alertSqsQueueURL    = var.alertSqsQueueURL
    }
  }
}

resource "aws_cloudwatch_event_rule" "c6" {
  name                = "${var.stageThreeLambdaTwo}-event-rule"
  description         = "Everyday every one min"
  schedule_expression = "cron(0/1 * ? * * *)"
}

resource "aws_cloudwatch_event_target" "c6" {
  rule      = aws_cloudwatch_event_rule.c6.name
  target_id = "lambda"
  arn       = aws_lambda_function.c6.arn
}

resource "aws_lambda_permission" "c6" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.c6.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.c6.arn
}
