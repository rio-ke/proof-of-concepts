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

_archive folder_

```tf
data "archive_file" "a5" {
  type        = "zip"
  source_dir  = "${path.module}/demo/"
  output_path = "${path.module}/demo.zip"
}

```
