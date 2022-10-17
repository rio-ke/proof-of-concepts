resource "aws_s3_bucket" "s2" {
  bucket = "stage-b1-bucket-s3"
  tags = {
    Name        = "b1-bucket-s3"
    Environment = "development"
  }
}
