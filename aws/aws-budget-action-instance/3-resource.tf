resource "aws_budgets_budget" "ec2" {
  name              = var.budgetName
  budget_type       = var.budget_type
  limit_amount      = var.limit_amount
  limit_unit        = var.limit_unit
  time_period_end   = var.time_period_end
  time_period_start = var.time_period_start
  time_unit         = var.timeUnit

  cost_filters = {
    TagKeyValue = "key$ec-data-platform"
  }

  cost_types {
    include_credit             = false
    include_discount           = false
    include_other_subscription = false
    include_recurring          = false
    include_refund             = false
    include_subscription       = true
    include_support            = false
    include_tax                = false
    include_upfront            = false
    use_blended                = false
  }
dynamic  notification {
  for_each = var.limits 
    content {
    comparison_operator        = "GREATER_THAN"
    threshold                  = notification.value
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.subscriber_email_addresses
  }
  }
}