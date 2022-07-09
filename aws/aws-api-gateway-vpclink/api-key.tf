resource "aws_api_gateway_api_key" "key" {
  name = "${var.api-gateway-name}-api-key"
}