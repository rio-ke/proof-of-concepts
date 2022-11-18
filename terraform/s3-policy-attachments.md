**s3-policy-attachments.md**

```tf
resource "aws_s3_bucket" "landingS3" {
  bucket = "${var.environment}-sde-master-ref-data-landing"
}

resource "aws_s3_bucket_policy" "landingS3" {
  bucket = aws_s3_bucket.landingS3.id
  policy = data.aws_iam_policy_document.landingS3.json
}

data "aws_iam_policy_document" "landingS3" {
  statement {
    sid = "arcresearch01access-1"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/FullAdminRole"]
    }
    actions = [
      "s3:PutObject*"
    ]
    resources = [
        "arn:aws:s3:::${aws_s3_bucket.landingS3.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.landingS3.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
  statement {
    sid = "arcresearch01access-2"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/FullAdminRole"]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
        "arn:aws:s3:::${aws_s3_bucket.landingS3.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.landingS3.bucket}/*"
    ]
  }
}
```
