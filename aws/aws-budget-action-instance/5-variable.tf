# variable "accessKey" {}
# variable "secretKey" {}
variable "region" {}
variable "budgetName" {}
variable "subscriber_email_addresses" {
  type = list(string)
}
variable "tagName" {}
variable "tagValue" {}
variable "timeUnit" {}
variable "limit_unit" {}
variable "limit_amount" {}
variable "budget_type" {}
variable "time_period_start" {}
variable "time_period_end" {}
variable "ActionSubType" {}
variable "group_email_address" {}
variable "limits" {
  type = list(string)
}

