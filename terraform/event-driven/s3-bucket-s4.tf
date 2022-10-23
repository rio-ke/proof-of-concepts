resource "aws_s3_bucket" "d1" {
  bucket = var.successBucket
}

resource "aws_s3_bucket_public_access_block" "d1" {
  bucket                  = aws_s3_bucket.d1.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "d2" {
  bucket = var.failureBucket
}

resource "aws_s3_bucket_public_access_block" "d2" {
  bucket                  = aws_s3_bucket.d2.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "d3" {
  bucket = var.logBucket
}

resource "aws_s3_bucket_public_access_block" "d3" {
  bucket                  = aws_s3_bucket.d3.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}