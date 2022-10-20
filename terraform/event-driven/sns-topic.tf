resource "aws_sns_topic" "s1" {
  name                        = "a3-sns-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}


resource "aws_sns_topic" "s2" {
  name                        = "b3-sns-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}


resource "aws_sns_topic" "s3" {
  name                        = "c3-sns-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}
