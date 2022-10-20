data "archive_file" "c2" {
  type        = "zip"
  source_file = "${path.module}/lambdaHandlers/c2.py"
  output_path = "${path.module}/lambdaHandlers/c2.py.zip"
}

resource "aws_lambda_function" "c2" {
  filename      = "${path.module}/lambdaHandlers/c2.py.zip"
  function_name = "op-c2-lambda"
  role          = aws_iam_role.common.arn
  handler       = "c2.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      snsArn = aws_sns_topic.c3.arn
    }
  }
}
