# aws_s3_bucket.bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = var.tags

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled    = true
    mfa_delete = false
  }

  website {
    index_document = "index.html"
  }
}

# aws_s3_bucket_policy.b:
resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode(
    {
      Id = "PolicyForCloudFrontPrivateContent"
      Statement = [
        {
          Action = "s3:GetObject"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2FRCTUOYI9N4S"
          }
          Resource = "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
          Sid      = "1"
        },
      ]
      Version = "2008-10-17"
    }
  )
}