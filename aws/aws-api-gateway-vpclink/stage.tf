resource "aws_api_gateway_deployment" "all" {
  depends_on  = [aws_api_gateway_integration.get]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"
}

resource "aws_api_gateway_stage" "all" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.all.id
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.yada.arn
    format          = <<EOF
{ "requestId":"$context.requestId", "ip": "$context.identity.sourceIp", "caller":"$context.identity.caller", "user":"$context.identity.user","requestTime":"$context.requestTime", "httpMethod":"$context.httpMethod","resourcePath":"$context.resourcePath", "status":"$context.status","protocol":"$context.protocol", "responseLength":"$context.responseLength" }
EOF
  }
}

resource "aws_api_gateway_method_settings" "post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.all.stage_name
  method_path = "${trimprefix(aws_api_gateway_resource.source.path, "/")}/${aws_api_gateway_method.post.http_method}"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_method_settings" "get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.all.stage_name
  method_path = "${trimprefix(aws_api_gateway_resource.source.path, "/")}/${aws_api_gateway_method.get.http_method}"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
