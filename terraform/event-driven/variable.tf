variable "region" {}
variable "stageOneBucket" {}
variable "stageTwoBucket" {}
variable "stageThreeBucket" {}
variable "successBucket" {}
variable "failureBucket" {}
# variable "logBucket" {}
variable "apigateway" {}
variable "stageOneSns" {}
variable "stageTwoSns" {}
variable "stageThreeSns" {}
variable "stageOneSqs" {}
variable "stageTwoSqs" {}
variable "stageThreeSqs" {}
variable "stageOneLambdaOne" {}
variable "stageOneLambdaTwo" {}
variable "stageTwoLambdaOne" {}
variable "stageTwoLambdaTwo" {}
variable "stageThreeLambdaOne" {}
variable "stageThreeLambdaTwo" {}
variable "infraZone" {}
variable "lambdaTimeout" {}
variable "sqsAlertQueue" {}

variable "default_tags" {
  description = "Default Tags for resources created by terraform"
  type        = map(string)
}