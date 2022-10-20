resource "aws_api_gateway_rest_api" "api" {
  name        = "op-api"
  description = "This API for op purposes"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
