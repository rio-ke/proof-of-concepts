data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/index.js.zip"
}

resource "aws_lambda_function" "get" {
  function_name = "get-${var.project}-${var.environment}-lambda"
  filename      = "${path.module}/index.js.zip"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.iam_for_lambda.arn
  timeout       = 30
}

resource "aws_cloudwatch_log_group" "get" {
  name              = "/aws/lambda/get-${var.project}-${var.environment}-lambda"
  retention_in_days = 14
}
resource "aws_lambda_function" "post" {
  function_name = "post-${var.project}-${var.environment}-lambda"
  filename      = "${path.module}/index.js.zip"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.iam_for_lambda.arn
  timeout       = 30
}

resource "aws_cloudwatch_log_group" "post" {
  name              = "/aws/lambda/post-${var.project}-${var.environment}-lambda"
  retention_in_days = 14
}

resource "aws_lambda_function" "put" {
  function_name = "put-${var.project}-${var.environment}-lambda"
  filename      = "${path.module}/index.js.zip"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.iam_for_lambda.arn
  timeout       = 30
}

resource "aws_cloudwatch_log_group" "put" {
  name              = "/aws/lambda/put-${var.project}-${var.environment}-lambda"
  retention_in_days = 14
}