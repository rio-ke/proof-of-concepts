variable "accessKey" {}
variable "secretKey" {}
variable "vpc_cidr" {}
variable "project" {}
variable "region" {}
variable "key-name" {}
variable "instance_type" {}
variable "public_subnet" {}
variable "public-subnet-1" {}
variable "private_subnet_1" {}
variable "private_subnet_2" {}

variable  "tagName" {}
variable  "tagValue" {}


variable "ports" {
  type = map(list(string))
  default = {
    "443"  = ["0.0.0.0/0"]
    "22"   = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
    "8080" = ["0.0.0.0/0"]
  }
}

variable "amis" {
  type = map(string)
  default = {
    eu-west-1 = "ami-0aef57767f5404a3c"
  }
}


variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Firewall resources, in addition to the resource group tags."
  default = {
    office-hours = "ec-data-platform"
  }
}

