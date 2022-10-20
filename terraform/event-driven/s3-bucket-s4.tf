resource "aws_s3_bucket" "d1" {
  bucket = "op-d1-bucket-s3-final-success"
}

resource "aws_s3_bucket" "d2" {
  bucket = "op-d2-bucket-s3-final-failure"
}