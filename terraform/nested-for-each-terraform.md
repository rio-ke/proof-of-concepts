_local reference_

```tf
locals {
  logFilterNames = var.ProtectionStepFnLogTrigger["${var.region}"]
}
```
_lambda invoke permission_

```tf
resource "aws_lambda_permission" "logging" {
  for_each      = local.logFilterNames
  action        = "lambda:InvokeFunction"
  function_name = "datadog-forwarder"
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/vendedlogs/states/${each.key}-sde-file_protection-step:*"
}
```

_cloudwatch log subscription filter_

```tf
resource "aws_cloudwatch_log_subscription_filter" "filter" {
  for_each        = var.ProtectionStepFnLogTrigger
  name            = each.key
  log_group_name  = lookup((each.value), "logGroupName")
  destination_arn = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder"
  filter_pattern  = ""
}

```

_variable_

```tf
# variable.tf
variable "ProtectionStepFnLogTrigger" {
  type    = any
  default = {}
}

```
_dev.tfvars_

```tf
ProtectionStepFnLogTrigger = {
  dev = {
    dev-sde-file_protection-step = {
      logGroupName = "/aws/vendedlogs/states/dev-sde-file_protection-step"
    }
    dev-s-e894b24e204c4bd5b = {
      logGroupName = "/aws/transfer/dev-s-e894b24e204c4bd5b"
    }
  },
  qa = {
    qa-sde-file_protection-step = {
      logGroupName = "/aws/vendedlogs/states/qa-sde-file_protection-step"
    }
    qa-s-e9a323a79eea49618 = {
      logGroupName = "/aws/transfer/qa-s-e9a323a79eea49618"
    }
  }
}

```
