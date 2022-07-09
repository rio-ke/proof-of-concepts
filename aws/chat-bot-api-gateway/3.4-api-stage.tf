resource "null_resource" "nullResource" {
  depends_on = [aws_api_gateway_vpc_link.vpclink, null_resource.nullResource]
  provisioner "local-exec" {
    command = "sleep 300"
  }
}

resource "aws_api_gateway_deployment" "all" {
  depends_on  = [aws_api_gateway_vpc_link.vpclink, null_resource.nullResource]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"
}

resource "aws_api_gateway_stage" "all" {
  stage_name    = "prod"
  depends_on    = [null_resource.nullResource]
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.all.id
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.cloudwatch_log.arn
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
  depends_on = [null_resource.nullResource]
}

resource "aws_api_gateway_method_settings" "get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.all.stage_name
  method_path = "${trimprefix(aws_api_gateway_resource.source.path, "/")}/${aws_api_gateway_method.get.http_method}"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
  depends_on = [null_resource.nullResource]
}
