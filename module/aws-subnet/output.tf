output "id" {
  value = { for k, v in aws_subnet.as : k => v.id }
}

output "arn" {
  value = { for k, v in aws_subnet.as : k => v.arn }
}
