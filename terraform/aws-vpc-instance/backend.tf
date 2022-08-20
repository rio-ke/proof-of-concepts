terraform {
  backend "s3" {
    bucket = "dodo-s3-buxket-terraform"
    key    = "aws-vpc-instance/terraform.tfstate"
    region = "us-east-1"
  }
}
