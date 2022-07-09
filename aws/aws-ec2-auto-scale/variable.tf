variable "vpc_cidr" {}
variable "project" {}
variable "region" {}
variable "key-name" {}
variable "instance_type" {}
variable "public-subnet-1" {}
variable "public-subnet-2" {}
variable "public-subnet-3" {}
variable "private-subnet-1" {}
variable "private-subnet-2" {}
variable "private-subnet-3" {}

variable "ports" {
  type = map(list(string))
  default = {
    "443"  = ["0.0.0.0/0"]
    "22"   = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
    "8080" = ["0.0.0.0/0"]
  }
}

variable "amis" {}


variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Firewall resources, in addition to the resource group tags."
  default = {
    office-hours = "ec-data-platform"
  }
}