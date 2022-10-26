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
    resources = [aws_sns_topic.c3.arn]
    sid       = "__sub_and_pub__"
  }
}

resource "aws_sns_topic" "c3" {
  name                        = var.stageThreeSns
  fifo_topic                  = true
  content_based_deduplication = true
  tags                        = merge(var.default_tags, { Name = "${var.stageThreeSns}" })

}

resource "aws_sns_topic_policy" "c3" {
  arn    = aws_sns_topic.c3.arn
  policy = data.aws_iam_policy_document.c3.json
}

resource "aws_sns_topic_subscription" "c3" {
  topic_arn            = aws_sns_topic.c3.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.c4.arn
  raw_message_delivery = true
}
