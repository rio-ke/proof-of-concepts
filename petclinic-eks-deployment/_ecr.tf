resource "aws_ecr_repository" "ecr" {
  name                 = "${var.eks_cluster_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"
  tags                 = merge({ Name = "${var.eks_cluster_name}-${var.environment}-ecr" }, tomap(var.additional_tags))

  image_scanning_configuration {
    scan_on_push = true
  }
}
