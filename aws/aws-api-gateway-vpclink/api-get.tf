resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.source.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.source.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.source.id
  http_method             = aws_api_gateway_method.get.http_method
  type                    = "HTTP"
  uri                     = "http://${aws_lb.lb.dns_name}/getdata"
  integration_http_method = "GET"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.example.id
}

resource "aws_api_gateway_integration_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.source.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = aws_api_gateway_method_response.get.status_code
}

