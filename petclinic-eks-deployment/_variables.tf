variable "eks_cluster_name" {}
variable "environment" {}
variable "vpc_cidr_block" {}
variable "private_subnet_cidr_block" {}
variable "public_subnet_cidr_blocks" {}
variable "availability_zones" {}
variable "region" {}
variable "eks-cw-logging" {
  type = list(any)
}

variable "worker-node-ssh-key" {}
variable "worker-node-max-size" {}
variable "worker-node-min-size" {}
variable "worker-node-desire-size" {}
variable "worker-node-instance-type" {}
variable "worker-node-disk-size" {}
variable "additional_tags" {
  type        = map(string)
  description = "Additional tags."
}