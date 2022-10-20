resource "aws_s3_bucket" "a1" {
  bucket = "op-a1-bucket-s3"
}

resource "aws_s3_bucket_notification" "a1" {
  bucket = aws_s3_bucket.a1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.a2.arn
    events              = ["s3:ObjectCreated:*"]
    id                  = "op-s3-to-lambda-notification"
  }
}
