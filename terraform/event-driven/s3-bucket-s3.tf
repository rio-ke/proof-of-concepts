
resource "aws_s3_bucket" "c1" {
  bucket = "op-abc1-bucket-s3"
}

resource "aws_lambda_permission" "c1" {
  statement_id  = "S3AllowInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.c2.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.c1.arn
}

# resource "null_resource" "a1" {
#   depends_on   = [aws_lambda_permission.c1]
#   provisioner "local-exec" {
#     command = "sleep 1m"
#   }
# }

resource "aws_s3_bucket_notification" "c1" {
  bucket = aws_s3_bucket.c1.id
  # depends_on   = [null_resource.c1]
  lambda_function {
    lambda_function_arn = aws_lambda_function.c2.arn
    events              = ["s3:ObjectCreated:*"]
    id                  = "op-s3-to-lambda-notification"
  }
}