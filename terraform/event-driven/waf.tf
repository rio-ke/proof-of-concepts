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

# resource "aws_wafv2_web_acl_association" "waf" {
#   resource_arn = aws_api_gateway_stage.example.arn
#   web_acl_arn  = aws_wafv2_web_acl.waf.arn
# }
