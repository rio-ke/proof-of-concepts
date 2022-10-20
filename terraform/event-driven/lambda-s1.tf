data "archive_file" "a2" {
  type        = "zip"
  source_file = "${path.module}/lambdaHandlers/a2.py"
  output_path = "${path.module}/lambdaHandlers/a2.py.zip"
}

resource "aws_lambda_function" "a2" {
  filename      = "${path.module}/lambdaHandlers/a2.py.zip"
  function_name = "op-a2-lambda"
  role          = aws_iam_role.common.arn
  handler       = "a2.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      snsArn = aws_sns_topic.a3.arn
    }
  }
}

data "archive_file" "a5" {
  type        = "zip"
  source_file = "${path.module}/lambdaHandlers/a5.py"
  output_path = "${path.module}/lambdaHandlers/a5.py.zip"
}

resource "aws_lambda_function" "a5" {
  filename      = "${path.module}/lambdaHandlers/a5.py.zip"
  function_name = "op-a5-lambda"
  role          = aws_iam_role.common.arn
  handler       = "a5.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      destination_bucket_name             = aws_s3_bucket.c1.bucket # abc1-bucket-s3
      replication_destination_bucket_name = aws_s3_bucket.b1.bucket # "b1-bucket-s3"
      sqsUrl                              = aws_sqs_queue.a4.url
    }
  }
}

resource "aws_lambda_event_source_mapping" "a5" {
  event_source_arn = aws_sqs_queue.a4.arn
  function_name    = aws_lambda_function.a5.arn
}