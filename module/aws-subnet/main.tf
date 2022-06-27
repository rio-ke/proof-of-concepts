resource "aws_subnet" "as" {
  for_each                                       = var.subnets
  vpc_id                                         = lookup(each.value, "vpc_id", var.vpc_id)
  assign_ipv6_address_on_creation                = lookup(each.value, "assign_ipv6_address_on_creation", false)
  availability_zone                              = lookup(each.value, "availability_zone", var.availability_zone)
  cidr_block                                     = lookup(each.value, "cidr_block", var.cidr_block)
  enable_dns64                                   = lookup(each.value, "enable_dns64", false)
  enable_resource_name_dns_a_record_on_launch    = lookup(each.value, "enable_resource_name_dns_a_record_on_launch", false)
  enable_resource_name_dns_aaaa_record_on_launch = lookup(each.value, "enable_resource_name_dns_aaaa_record_on_launch", false)
  ipv6_native                                    = lookup(each.value, "ipv6_native", false)
  map_public_ip_on_launch                        = lookup(each.value, "map_public_ip_on_launch", false)
  tags                                           = merge({ Name = each.key }, tomap(lookup(each.value, "tags", {})))
}

