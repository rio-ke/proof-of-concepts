variable "awsManagedRoles" {
  type        = list(string)
  default     = ["AmazonSSMFullAccess", "AmazonSSMManagedInstanceCore", "AmazonSSMPatchAssociation", "CloudWatchFullAccess", "CloudWatchAgentAdminPolicy", "CloudWatchAgentServerPolicy"]
  description = "List of StringList(s)"
}
variable "ssmParameterName" {}
variable "alarm_actions" {}
variable "alarm_ok_actions" {}
variable "roleName" {}
variable "creationOfIamInstanceProfile" { default = false }
variable "instancesDetails" {
  type    = any
  default = {}
}
variable "tags" {
  type    = any
  default = {}
}
