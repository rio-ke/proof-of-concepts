resource "aws_lb" "anlb" {
  for_each                         = var.nlbs
  enable_cross_zone_load_balancing = lookup(each.value, "enable_cross_zone_load_balancing", true)
  enable_deletion_protection       = lookup(each.value, "enable_deletion_protection", false)
  internal                         = lookup(each.value, "internal", true)
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = each.key
  security_groups                  = []
  vpc_id                           = lookup(each.value, "vpc_id", var.vpc_id)
  tags                             = merge({ Name = each.key }, tomap(lookup(each.value, "tags", local.tags)))
  subnets                          = lookup(each.value, "subnets")
  access_logs {
    enabled = false
  }
}
