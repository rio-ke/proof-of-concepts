```tf
resource "aws_sns_topic" "ast" {
  name = var.topicName
}

resource "aws_sns_topic_subscription" "asts" {
  for_each   = toset(local.subscriptionEmailLists)
  topic_arn = aws_sns_topic.ast.arn
  protocol  = "email"
  endpoint  = each.value
}

locals {
  subscriptionEmailLists = var.emailList
}

variable "topicName" {
  default = "dodo-topic"
}

variable "emailList" {
  type        = list(string)
  default     = ["jinojoe@gmail.com"]
  description = "List of StringList(s)"
}

```
