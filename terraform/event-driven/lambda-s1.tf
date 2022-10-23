data "archive_file" "a2" {
  type        = "zip"
  source_file = "${path.module}/lambdaHandlers/a2.py"
  output_path = "${path.module}/lambdaHandlers/a2.py.zip"
}

resource "aws_lambda_function" "a2" {
  # filename      = filebase64sha256("${path.module}/lambdaHandlers/a2.py.zip")
  filename      = filebase64sha256(data.archive_file.a2.output_path) 
  function_name = var.stageOneLambdaOne 
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
  # filename      = filebase64sha256("${path.module}/lambdaHandlers/a5.py.zip")
  filename      = filebase64sha256(data.archive_file.a5.output_path) 
  function_name = var.stageOneLambdaTwo 
  role          = aws_iam_role.common.arn
  handler       = "a5.lambda_handler"
  runtime       = "python3.9"
  layers        = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      metadataBucket = aws_s3_bucket.c1.bucket 
      scanningBucket = aws_s3_bucket.b1.bucket
      sqsUrl         = aws_sqs_queue.a4.url
    }
  }
}

resource "aws_lambda_event_source_mapping" "a5" {
  event_source_arn = aws_sqs_queue.a4.arn
  function_name    = aws_lambda_function.a5.arn
}
