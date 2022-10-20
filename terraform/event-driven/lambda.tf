data "archive_file" "s1" {
  type        = "zip"
  source_file = "${path.module}/stageOne/a2.py"
  output_path = "${path.module}/stageOne/a2.py.zip"
}

resource "aws_lambda_function" "s1" {
  filename      = "${path.module}/stageOne/a2.py.zip"
  function_name = "stage-a2-lambda"
  role          = aws_iam_role.s1.arn
  handler       = "a2.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      snsArn = aws_sns_topic.s1.arn
    }
  }
}


data "archive_file" "a2" {
  type        = "zip"
  source_file = "${path.module}/stageOne/a5.py"
  output_path = "${path.module}/stageOne/a5.py.zip"
}

resource "aws_lambda_function" "a5" {
  filename      = "${path.module}/stageOne/a5.py.zip"
  function_name = "stage-a5-lambda"
  role          = aws_iam_role.s1.arn
  handler       = "a5.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      destination_bucket_name = aws_s3_bucket.s21.bucket                                              # abc1-bucket-s3
      replication_destination_bucket_name = aws_s3_bucket.s22.bucket                                  # "b1-bucket-s3"
      sqsUrl = aws_sqs_queue.s1.url                               
    }
  }
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.s1.arn
  function_name    = aws_lambda_function.a5.arn
}
