# variable "accessKey" {}
# variable "secretKey" {}
variable "region" {}
variable "project" {}
variable "environment" {}
variable "route53_domain" {}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Firewall resources, in addition to the resource group tags."
  default = {
    office-hours = "ec-data-platform"
  }
}

# https://github.com/worldofprasanna/terraform-aws-staticwebsite
# https://blog.francium.tech/how-to-serve-your-website-from-aws-s3-using-terraform-94dfd16324bf