output "ecr-arn" {
  value = {for k, v in aws_ecr_repository.aer: k => v.arn}
}

output "ecr-url" {
  value = {for k, v in aws_ecr_repository.aer: k => v.repository_url}
}


# output "target-groups-arn" {
#   value = values(aws_lb_target_group.target-group)[*].arn
# }