output "id" {
  value = data.aws_vpc.av.id
}

output "arn" {
  value = data.aws_vpc.av.arn
}

output "mrtid" {
  value = data.aws_vpc.av.main_route_table_id
}

output "cidr_block" {
  value = data.aws_vpc.av.cidr_block
}