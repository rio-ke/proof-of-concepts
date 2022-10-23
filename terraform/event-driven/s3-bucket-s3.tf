resource "aws_s3_bucket" "c1" {
  bucket = var.stageThreeBucket
  logging {
    target_bucket = aws_s3_bucket.d3.id
    target_prefix = "log/${var.stageThreeBucket}/"
  }
}

resource "aws_lambda_permission" "c1" {
  statement_id  = "S3AllowInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.c2.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.c1.arn
}

resource "aws_s3_bucket_notification" "c1" {
  bucket = aws_s3_bucket.c1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.c2.arn
    events              = ["s3:ObjectCreated:*"]
    id                  = "op-s3-to-lambda-notification"
  }
}
