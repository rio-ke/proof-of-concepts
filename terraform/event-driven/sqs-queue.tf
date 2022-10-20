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


