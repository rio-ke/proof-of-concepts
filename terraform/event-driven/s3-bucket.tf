resource "aws_s3_bucket" "s1" {
  bucket = "dodo-a1-bucket-s3"
}

resource "aws_s3_bucket_notification" "s1" {
  bucket = aws_s3_bucket.s1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.s1.arn
    events              = ["s3:ObjectCreated:*"]
    id                  = "dodo-a2-s3-to-lambda-notification"
  }
}

resource "aws_s3_bucket" "s22" {
  bucket = "dodo-b1-bucket-s3"
}

resource "aws_s3_bucket_notification" "b1" {
  bucket = aws_s3_bucket.s22.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.b2.arn
    events              = ["s3:ObjectTagging:*"]
    id                  = "dodo-a2-s3-to-lambda-tag-notification"
  }
}

resource "aws_s3_bucket" "s21" {
  bucket = "dodo-abc1-bucket-s3"
}

resource "aws_s3_bucket_notification" "c1" {
  bucket = aws_s3_bucket.s21.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.c2.arn
    events              = ["s3:ObjectTagging:*"]
    id                  = "dodo-a2-s3-to-lambda-tag-notification"
  }
}
