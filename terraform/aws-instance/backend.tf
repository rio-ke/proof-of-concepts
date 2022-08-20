terraform {
  backend "s3" {
    bucket = "dodo-s3-buxket-terraform"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
