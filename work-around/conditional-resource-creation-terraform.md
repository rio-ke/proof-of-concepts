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

other environment should be `uat.tfvars` and `prod.tfvars`

```tf
resourceCreation=false
```
