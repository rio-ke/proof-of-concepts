variable "vpc_cidr" {}
variable "project" {}
variable "accessKey" {}
variable "secretKey" {}
variable "region" {}
variable "key-name" {}

variable "ports" {
  type = map(list(string))
  default = {
    "443" = ["0.0.0.0/0"]
    "22"  = ["0.0.0.0/0"]
    "80"  = ["0.0.0.0/0"]
  }
}

variable "amis" {
  type = map(string)
  default = {
    eu-west-1 = "ami-0e2afec765bb99e9d"
  }
}