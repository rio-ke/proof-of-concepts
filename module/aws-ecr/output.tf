output "ecr-arn" {
  value = {for k, v in aws_ecr_repository.aer: k => v.arn}
}
