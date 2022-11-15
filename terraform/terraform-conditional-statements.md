**terraform-conditional-statements.md**

```tf
locals {
  data = var.env == "prod" ? "prod" : (var.env == "qa" ? "qa" : (var.env == "uat" ? "uat" : "dev"))
}

output "de" {
  value = local.data
}

variable "env" {
  default = "dev"
}

provider "aws" {}

```
