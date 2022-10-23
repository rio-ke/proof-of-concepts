# resource "aws_s3_bucket" "c1" {
#   bucket = var.stageThreeBucket
# }

# resource "aws_s3_bucket_public_access_block" "c1" {
#   bucket                  = aws_s3_bucket.c1.id
#   block_public_acls       = true
#   block_public_policy     = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_logging" "c1" {
#   bucket        = aws_s3_bucket.c1.id
#   target_bucket = aws_s3_bucket.d3.id
#   target_prefix = "log/${var.stageThreeBucket}/"
# }

data "aws_s3_bucket" "c1" {
  bucket = var.stageThreeBucket
}

resource "aws_lambda_permission" "c1" {
  statement_id  = "S3AllowInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.c2.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.c1.arn
}

resource "aws_s3_bucket_notification" "c1" {
  bucket = data.aws_s3_bucket.c1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.c2.arn
    events              = ["s3:ObjectTagging:*"]
    id                  = "${var.stageThreeBucket}-s3-to-lambda-notification"
  }
}

