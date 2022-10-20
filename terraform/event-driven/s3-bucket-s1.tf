resource "aws_s3_bucket" "a1" {
  bucket = "op-a1-bucket-s3"
}

resource "aws_lambda_permission" "a1" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.a2.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.a1.arn
}

resource "null_resource" "a1" {
  depends_on   = [aws_lambda_permission.a1]
  provisioner "local-exec" {
    command = "sleep 1m"
  }
}

resource "aws_s3_bucket_notification" "a1" {
  bucket = aws_s3_bucket.a1.id
  depends_on   = [null_resource.a1]
  lambda_function {
    lambda_function_arn = aws_lambda_function.a2.arn
    events              = ["s3:ObjectCreated:*"]
    id                  = "op-s3-to-lambda-notification"
  }
}
