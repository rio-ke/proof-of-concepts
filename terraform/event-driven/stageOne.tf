resource "aws_s3_bucket" "s1" {
  bucket = "stage-a1-bucket-s3"
  tags = {
    Name        = "a1-bucket-s3"
    Environment = "development"
  }
}

resource "aws_lambda_layer_version" "l1" {
  filename   = "${path.module}/layer/boto3.zip"
  layer_name = "currentBoto3"
  compatible_runtimes = ["python3.9"]
  compatible_architectures =  ["x86_64"]
}

resource "aws_lambda_layer_version" "l2" {
  filename   = "${path.module}/layer/request.zip"
  layer_name = "currentRequest"
  compatible_runtimes = ["python3.9"]
  compatible_architectures =  ["x86_64"]
}

data "archive_file" "s1" {
  type        = "zip"
  source_file = "${path.module}/stageOne/a2.py"
  output_path = "${path.module}/stageOne/a2.py.zip"
}

resource "aws_iam_role" "s1" {
  name = "stage-a2-lambda-lambda-role"
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

resource "aws_iam_policy" "s1" {
  name = "stage-a2-lambda-lambda-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s1" {
  role       = aws_iam_role.s1.name
  policy_arn = aws_iam_policy.s1.arn
}
resource "aws_lambda_function" "s1" {
  filename      = "${path.module}/stageOne/a2.py.zip"
  function_name = "stage-a2-lambda"
  role          = aws_iam_role.s1.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      snsArn = aws_sns_topic.s1.arn
    }
  }
}

resource "aws_sns_topic" "s1" {
  name                        = "a3-sns-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}


resource "aws_s3_bucket_notification" "s1" {
  bucket = aws_s3_bucket.s1.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s1.arn
    events              = ["s3:ObjectCreated:*"]
    id                  = "stage-a2-s3-to-lambda-notification"
  }
}

resource "aws_sqs_queue" "s1" {
  name                        = "a4-sqs-queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perQueue"
}
resource "aws_sqs_queue_policy" "s1" {
  queue_url = aws_sqs_queue.s1.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "sqspolicy",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        },
        "Action" : "SQS:SendMessage",
        "Resource" : "${aws_sqs_queue.s1.arn}",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "${aws_sns_topic.s1.arn}"
          }
        }
      }
    ]
  })
}


resource "aws_sns_topic_subscription" "s1" {
  topic_arn = aws_sns_topic.s1.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.s1.arn
}


data "aws_iam_policy_document" "s1" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:AddPermission",
      "SNS:Subscribe"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_sns_topic.s1.arn]
    sid       = "_sub_and_pub_"
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.s1.arn
  policy = data.aws_iam_policy_document.s1.json
}

data "aws_caller_identity" "current" {}


data "archive_file" "a2" {
  type        = "zip"
  source_file = "${path.module}/stageOne/a5.py"
  output_path = "${path.module}/stageOne/a5.py.zip"
}

resource "aws_lambda_function" "a5" {
  filename      = "${path.module}/stageOne/a5.py.zip"
  function_name = "stage-a5-lambda"
  role          = aws_iam_role.s1.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.l1.arn, aws_lambda_layer_version.l2.arn]
  environment {
    variables = {
      snsArn = aws_sns_topic.s1.arn
    }
  }
}
