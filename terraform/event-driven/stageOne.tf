resource "aws_s3_bucket" "s1" {
  bucket = "a1-bucket-s3"
  tags = {
    Name        = "a1-bucket-s3"
    Environment = "development"
  }
}
