resource "aws_api_gateway_resource" "graph" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "graphs"
  depends_on  = [aws_api_gateway_vpc_link.vpclink]
}

resource "aws_api_gateway_method" "graph" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.graph.id
  http_method   = "GET"
  authorization = "NONE"
  depends_on    = [aws_api_gateway_vpc_link.vpclink]
}
resource "aws_api_gateway_method_response" "graph" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.graph.id
  http_method = aws_api_gateway_method.graph.http_method
  status_code = "200"
  depends_on  = [aws_api_gateway_vpc_link.vpclink]
}
resource "aws_api_gateway_integration" "graph" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.graph.id
  http_method             = aws_api_gateway_method.graph.http_method
  type                    = "HTTP"
  uri                     = "http://${aws_elb.elb.dns_name}/"
  integration_http_method = "GET"
  depends_on              = [aws_api_gateway_vpc_link.vpclink]
}

resource "aws_api_gateway_integration_response" "graph" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.graph.id
  http_method = aws_api_gateway_method.graph.http_method
  status_code = aws_api_gateway_method_response.graph.status_code
  depends_on  = [aws_api_gateway_vpc_link.vpclink]
}
