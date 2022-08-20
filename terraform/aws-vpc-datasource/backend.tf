terraform {
  backend "s3" {
    bucket = "dodo-s3-buxket-terraform"
    key    = "dev/datasource/terraform.tfstate"
    region = "us-east-1"
  }
}
