resource "aws_s3_bucket" "d1" {
  bucket = "dodo-d1-bucket-s3-final-success"
}

resource "aws_s3_bucket" "d2" {
  bucket = "dodo-d2-bucket-s3-final-failure"
}