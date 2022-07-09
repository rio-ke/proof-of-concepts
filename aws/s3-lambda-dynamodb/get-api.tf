

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
  resource_id   = aws_api_gateway_resource.apiLambda.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.apiLambda.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.apiLambda.id
  resource_id             = aws_api_gateway_resource.apiLambda.id
  http_method             = aws_api_gateway_method.get.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get.invoke_arn
  integration_http_method = "GET"
}

resource "aws_api_gateway_integration_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.apiLambda.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = aws_api_gateway_method_response.get.status_code
}