data "aws_sqs_queue" "alert" {
  name = var.sqsAlertQueue
}