data "aws_iam_policy_document" "a3" {
  policy_id = "__default_policy__"
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
        data.aws_caller_identity.account.account_id
      ]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_sns_topic.s1.arn]
    sid       = "__sub_and_pub__"
  }
}

# First stage

resource "aws_sns_topic" "s1" {
  name                        = "a3-sns-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}

resource "aws_sns_topic_subscription" "s1" {
  topic_arn = aws_sns_topic.s1.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.s1.arn
}

resource "aws_sns_topic_policy" "s1" {
  arn    = aws_sns_topic.s1.arn
  policy = data.aws_iam_policy_document.a2.json
}


## second stage

data "aws_iam_policy_document" "b3" {
  policy_id = "__default_policy__"
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
        data.aws_caller_identity.account.account_id
      ]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_sns_topic.s2.arn]
    sid       = "__sub_and_pub__"
  }
}
resource "aws_sns_topic" "s2" {
  name                        = "b3-sns-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}

resource "aws_sns_topic_policy" "s2" {
  arn    = aws_sns_topic.s2.arn
  policy = data.aws_iam_policy_document.b3.json
}

resource "aws_sns_topic_subscription" "s2" {
  topic_arn = aws_sns_topic.s2.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.s2.arn
}

## Third stage

data "aws_iam_policy_document" "c3" {
  policy_id = "__default_policy__"
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
        data.aws_caller_identity.account.account_id
      ]
    }
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_sns_topic.s3.arn]
    sid       = "__sub_and_pub__"
  }
}
resource "aws_sns_topic" "s3" {
  name                        = "c3-sns-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}

resource "aws_sns_topic_policy" "s3" {
  arn    = aws_sns_topic.s3.arn
  policy = data.aws_iam_policy_document.c3.json
}

resource "aws_sns_topic_subscription" "s3" {
  topic_arn = aws_sns_topic.s3.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.s3.arn
}
