resource "aws_s3_bucket" "d1" {
  bucket = var.successBucket
}

resource "aws_s3_bucket_acl" "d1" {
  bucket = aws_s3_bucket.d1.id
  acl    = "private"
}

resource "aws_s3_bucket" "d2" {
  bucket = var.failureBucket
}

resource "aws_s3_bucket_acl" "d2" {
  bucket = aws_s3_bucket.d2.id
  acl    = "private"
}

resource "aws_s3_bucket" "d3" {
  bucket = var.logBucket
}

resource "aws_s3_bucket_acl" "d3" {
  bucket = aws_s3_bucket.d3.id
  acl    = "private"
}
