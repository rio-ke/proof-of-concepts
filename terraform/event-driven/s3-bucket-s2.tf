resource "aws_s3_bucket" "b1" {
  bucket = var.stageTwoBucket
}

resource "aws_s3_bucket_public_access_block" "b1" {
  bucket                  = aws_s3_bucket.b1.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "b1" {
  bucket        = aws_s3_bucket.b1.id
  target_bucket = aws_s3_bucket.d3.id
  target_prefix = "log/${var.stageTwoBucket}/"
}

resource "aws_lambda_permission" "b1" {
  statement_id  = "S3AllowInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.b2.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.b1.arn
}

resource "aws_s3_bucket_notification" "b1" {
  bucket = aws_s3_bucket.b1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.b2.arn
    events              = ["s3:ObjectTagging:*"]
    id                  = "${var.stageTwoBucket}-s3-to-lambda-notification"
  }
}


