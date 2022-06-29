resource "aws_ecr_repository" "aer" {
  for_each             = var.ecr_repositories
  image_tag_mutability = "MUTABLE"
  name                 = each.key
  tags                 = merge({ Name = each.key }, tomap(lookup(each.value, "tags", local.tags)))
  encryption_configuration {
    encryption_type = lookup(each.value, "encryption_type", "AES256")
  }
  image_scanning_configuration {
    scan_on_push = lookup(each.value, "scan_on_push", false)
  }
}


