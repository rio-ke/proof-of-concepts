resource "aws_s3_bucket" "b1" {
  bucket = "op-b1-bucket-s3"
}

resource "aws_lambda_permission" "b1" {
  statement_id  = "S3AllowInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.b2.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.b1.arn
}

# resource "null_resource" "b1" {
#   depends_on   = [aws_lambda_permission.b1]
#   provisioner "local-exec" {
#     command = "sleep 1m"
#   }
# }

resource "aws_s3_bucket_notification" "b1" {
  bucket = aws_s3_bucket.b1.id
  # depends_on   = [null_resource.b1]
  lambda_function {
    lambda_function_arn = aws_lambda_function.b2.arn
    events              = ["s3:ObjectTagging:*"]
    id                  = "op-s3-to-lambda-notification"
  }
}
