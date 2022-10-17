resource "aws_s3_bucket" "s3" {
  bucket = "abc1-bucket-s3"
  tags = {
    Name        = "abc1-bucket-s3"
    Environment = "development"
  }
}
