provider "aws" {
  access_key = var.accessKey
  secret_key = var.secretKey
  region     = var.region
}

terraform {
  required_version = ">= 0.12"
}
