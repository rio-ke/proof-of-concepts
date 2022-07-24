# output.tf
output "id" {
  value = { for k, v in aws_vpc_endpoint.ave : k => v.id }
}

output "arn" {
  value = { for k, v in aws_vpc_endpoint.ave : k => v.arn }
}
