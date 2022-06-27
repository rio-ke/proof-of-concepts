output "aws_subnet_id" {
  value = { for k, v in aws_subnet.as : k => v.id }
}

output "aws_subnet_arn" {
  value = { for k, v in aws_subnet.as : k => v.arn }
}
