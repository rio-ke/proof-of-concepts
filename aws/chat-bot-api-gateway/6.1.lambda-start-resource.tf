data "archive_file" "startArchiveFile" {
  type        = "zip"
  source_file = "${path.module}/scripts/python-start/main.py"
  output_path = "${path.module}/scripts/python-start/main.py.zip"
}

resource "aws_lambda_function" "startLambda" {
  filename         = "${path.module}/scripts/python-start/main.py.zip"
  function_name    = "${var.project}-EC2-start-lambda-function"
  role             = aws_iam_role.iam_lambda.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.8"

  environment {
    variables = {
      region = var.region
      tagvalue = var.tagValue
      tagname = var.tagName
    }
  }
}

resource "aws_cloudwatch_event_rule" "startEventRule" {
  name                = "${var.project}-start-event-rule"
  description         = "7-00 AM Monday through Fridays"
  schedule_expression = "cron(0 7 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "startEventTarget" {
  rule      = aws_cloudwatch_event_rule.startEventRule.name
  target_id = "lambda"
  arn       = aws_lambda_function.startLambda.arn
}


resource "aws_lambda_permission" "startLambdaPermission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.startLambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.startEventRule.arn
}
