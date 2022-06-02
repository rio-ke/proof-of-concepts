provider "aws" {
  region     = var.region
  # access_key = ""
  # secret_key = ""
}

terraform {
  backend "s3" {}
}
