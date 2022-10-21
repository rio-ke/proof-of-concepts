resource "aws_wafv2_web_acl" "waf" {
  name  = "${var.apigateway}-waf"
  scope = "REGIONAL"
  default_action {
    allow {}
  }
#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "friendly-metric-name"
#     sampled_requests_enabled   = false
#   }
}
