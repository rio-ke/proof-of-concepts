resource "aws_sqs_queue" "b4" {
  name                        = var.stageTwoSqs
  fifo_queue                  = true
  content_based_deduplication = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perQueue"
  tags                        = merge(var.default_tags, { Name = "${var.stageTwoSqs}" })

}

resource "aws_sqs_queue_policy" "b4" {
  queue_url = aws_sqs_queue.b4.id
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
        "Resource" : "${aws_sqs_queue.b4.arn}",
        "Condition" : {
          "ArnLike" : {
            "aws:SourceArn" : "${aws_sns_topic.b3.arn}"
          }
        }
      }
    ]
  })
}
