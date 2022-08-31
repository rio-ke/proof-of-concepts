variable "awsManagedRoles" {
  type        = list(string)
  default     = ["AmazonSSMFullAccess", "AmazonSSMManagedInstanceCore", "AmazonSSMPatchAssociation", "CloudWatchFullAccess"]
  description = "List of StringList(s)"
}

variable "ssmParameterName" {
  default = "AmazonCloudWatch-windows-parameter"
}

variable "roleName" {
  default = "dodo-instance"
}
