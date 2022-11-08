conditional-resource-creation-terraform.md

```tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "b" {
  count  = var.resourceCreation == true ? 1 : 0
  bucket = "my-tf-test-bucket"
}

# If you want to create the resource that value should be set as true

variable "resourceCreation" {
  default = false
}
```
