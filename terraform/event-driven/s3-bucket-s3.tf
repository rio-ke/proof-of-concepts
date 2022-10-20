
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


# resource "aws_s3_bucket" "s31" {
#   bucket = "dodo-d1-bucket-s3-final-success"
# }

# resource "aws_s3_bucket" "s32" {
#   bucket = "dodo-d1-bucket-s3-final-failure"
# }
