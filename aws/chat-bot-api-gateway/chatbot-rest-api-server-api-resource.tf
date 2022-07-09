resource "aws_api_gateway_rest_api" "chatbot-rest-api" {
  name        = "${var.project}-chatbot-rest-api"
  description = "neo4j and graph server apis"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  depends_on = [aws_api_gateway_vpc_link.vpclink]

}
