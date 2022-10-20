data "archive_file" "s1" {
  type        = "zip"
  source_file = "${path.module}/stageOne/a2.py"
  output_path = "${path.module}/stageOne/a2.py.zip"
}

resource "aws_lambda_function" "s1" {
  filename      = "${path.module}/stageOne/a2.py.zip"
  function_name = "stage-a2-lambda"
  role          = aws_iam_role.common.arn
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
  role          = aws_iam_role.common.arn
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

resource "aws_lambda_event_source_mapping" "a5" {
  event_source_arn = aws_sqs_queue.s1.arn
  function_name    = aws_lambda_function.a5.arn
}


data "archive_file" "b2" {
  type        = "zip"
  source_file = "${path.module}/stageOne/b2.py"
  output_path = "${path.module}/stageOne/b2.py.zip"
}

resource "aws_lambda_function" "b2" {
  filename      = "${path.module}/stageOne/b2.py.zip"
  function_name = "stage-b2-lambda"
  role          = aws_iam_role.common.arn
  handler       = "b2.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      snsArn = aws_sns_topic.s2.arn
    }
  }
}


data "archive_file" "b5" {
  type        = "zip"
  source_file = "${path.module}/stageOne/b5.py"
  output_path = "${path.module}/stageOne/b5.py.zip"
}

resource "aws_lambda_function" "s1" {
  filename      = "${path.module}/stageOne/b5.py.zip"
  function_name = "stage-b5-lambda"
  role          = aws_iam_role.common.arn
  handler       = "b5.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      destination_bucket_name = aws_s3_bucket.s21.bucket                                              # abc1-bucket-s3
      sqsUrl = aws_sqs_queue.s2.url                          
    }
  }
}

resource "aws_lambda_event_source_mapping" "b5" {
  event_source_arn = aws_sqs_queue.s2.arn
  function_name    = aws_lambda_function.b5.arn
}

data "archive_file" "c2" {
  type        = "zip"
  source_file = "${path.module}/stageOne/c2.py"
  output_path = "${path.module}/stageOne/c2.py.zip"
}

resource "aws_lambda_function" "c2" {
  filename      = "${path.module}/stageOne/c2.py.zip"
  function_name = "stage-c2-lambda"
  role          = aws_iam_role.common.arn
  handler       = "c2.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      snsArn = aws_sns_topic.s3.arn
    }
  }
}
