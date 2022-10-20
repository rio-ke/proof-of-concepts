resource "aws_s3_bucket" "b1" {
  bucket = "dodo-b1-bucket-s3"
}

resource "aws_s3_bucket_notification" "b1" {
  bucket = aws_s3_bucket.b1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.b2.arn
    events              = ["s3:ObjectTagging:*"]
    id                  = "dodo-a2-s3-to-lambda-tag-notification"
  }
}