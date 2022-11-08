conditional-resource-creation-terraform.md

```tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "b" {
  count  = var.resourceCreation == true ? 1 : 0
  bucket = "my-tf-test-bucket"
}

variable "resourceCreation" {}
```


dev.tfvars

```tf
resourceCreation=true
```

other environment should be prod.tfvars

```tf
resourceCreation=false
```
