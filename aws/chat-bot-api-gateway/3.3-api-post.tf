
resource "aws_api_gateway_resource" "source" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "neo4j"
  depends_on          = [aws_api_gateway_vpc_link.vpclink]

}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.source.id
  http_method   = "POST"
  authorization = "NONE"
  depends_on          = [aws_api_gateway_vpc_link.vpclink]

}

resource "aws_api_gateway_integration" "post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.source.id
  http_method             = aws_api_gateway_method.post.http_method
  type                    = "HTTP"
  uri                     = "http://${aws_lb.lb.dns_name}/adddata"
  integration_http_method = "POST"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.vpclink.id
  depends_on          = [aws_api_gateway_vpc_link.vpclink]
  # depends_on              = [aws_api_gateway_rest_api.api, aws_api_gateway_method.post]

}

resource "aws_api_gateway_method_response" "post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.source.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"
  depends_on          = [aws_api_gateway_vpc_link.vpclink]

}

resource "aws_api_gateway_integration_response" "post" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.source.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.post.status_code
  depends_on          = [aws_api_gateway_vpc_link.vpclink]

}

