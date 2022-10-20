resource "aws_lambda_layer_version" "l1" {
  filename   = "${path.module}/layer/boto3.zip"
  layer_name = "currentBoto3"
  compatible_runtimes = ["python3.9"]
  compatible_architectures =  ["x86_64"]
}

resource "aws_lambda_layer_version" "l2" {
  filename   = "${path.module}/layer/request.zip"
  layer_name = "currentRequest"
  compatible_runtimes = ["python3.9"]
  compatible_architectures =  ["x86_64"]
}
