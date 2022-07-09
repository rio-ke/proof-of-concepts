data "archive_file" "stopArchiveFile" {
  type        = "zip"
  source_file = "${path.module}/scripts/python-stop/main.py"
  output_path = "${path.module}/scripts/python-stop/main.py.zip"
}

resource "aws_lambda_function" "stopLambda" {
  filename      = "${path.module}/scripts/python-stop/main.py.zip"
  function_name = "${var.project}-EC2-stop-lambda-function"
  role          = aws_iam_role.iam_lambda.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
  environment {
    variables = {
      region   = var.region
      tagvalue = var.tagValue
      tagname  = var.tagName
    }
  }
}

resource "aws_cloudwatch_event_rule" "stopEventRule" {
  name                = "${var.project}-stop-event-rule"
  description         = "23-00 PM Monday through Fridays"
  schedule_expression = "cron(0 23 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "stopEventTarget" {
  rule      = aws_cloudwatch_event_rule.stopEventRule.name
  target_id = "lambda"
  arn       = aws_lambda_function.stopLambda.arn
}

resource "aws_lambda_permission" "stopLambdaPermission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stopLambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stopEventRule.arn
}