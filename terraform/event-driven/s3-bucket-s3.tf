
resource "aws_s3_bucket" "c1" {
  bucket = "dodo-abc1-bucket-s3"
}

resource "aws_s3_bucket_notification" "c1" {
  bucket = aws_s3_bucket.c1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.c2.arn
    events              = ["s3:ObjectTagging:*"]
    id                  = "dodo-a2-s3-to-lambda-tag-notification"
  }
}

