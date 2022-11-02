

```tf
resource "datadog_monitor" "step-execution-error" {
  evaluation_delay     = 900
  include_tags         = true
  locked               = false
  message              = <<-EOT
        {{#is_alert}}
        A Step Function execution for the following ARN has failed: {{statemachinearn.name}}
        Please review the Step Function execution to correct the issue: 
        https://...
        {{/is_alert}} mailid
    EOT
  name                 = "${var.stepFunctionName}-execution-error"
  new_group_delay      = 0
  new_host_delay       = 300
  no_data_timeframe    = 0
  notify_audit         = false
  notify_by            = []
  notify_no_data       = false
  priority             = 0
  query                = "sum(last_5m):sum:aws.states.executions_failed{statemachinearn:arn:aws:states:${var.region}:${aws_caller_identity.current.account_id}:statemachine:${var.stepFunctionName}}.as_count() > 0"
  renotify_interval    = 0
  renotify_occurrences = 0
  require_full_window  = false
  tags                 = []
  timeout_h            = 0
  type                 = "query alert"

  monitor_thresholds {
    critical = "0"
  }
}

variable "stepFunctionName" {}
```
