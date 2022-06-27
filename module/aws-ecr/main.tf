resource "aws_ecr_repository" "aer" {
  for_each             = var.ecr_repositories # "${var.eks_cluster_name}-${var.environment}-eks"
  image_tag_mutability = "MUTABLE"
  name                 = each.key
  tags                 = merge({ Name = each.key }, tomap(var.additional_tags))
  encryption_configuration {
    encryption_type = lookup(each.encryption_type, "AES256")
  }
  image_scanning_configuration {
    scan_on_push = lookup(each.scan_on_push, false)
  }
}


