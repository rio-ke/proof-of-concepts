# This is an example of what a provider looks like.
#
provider "aws" {
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}
