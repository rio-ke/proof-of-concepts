

resource "aws_s3_bucket" "main" {
  bucket = "${var.project}-react-${var.environment}"
  acl    = "private"
  policy = data.aws_iam_policy_document.bucket_policy.json
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  force_destroy = false
  tags          = merge(map("Name", "${var.project}-${var.environment}-s3-bucket"), var.additional_tags)
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowReadFromAll"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${var.project}-react-${var.environment}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


