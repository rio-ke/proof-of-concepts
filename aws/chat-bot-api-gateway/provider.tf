provider "aws" {
  region = var.region
  access_key = var.accessKey
  secret_key = var.secretKey
}


terraform {
  required_providers {
    archive = "~> 1.3"
  }
}
