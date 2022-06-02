# Nodes in private subnets
resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.eks_cluster_name}-${var.environment}-private-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = flatten([aws_subnet.private_subnet.*.id])
  ami_type        = "AL2_x86_64"
  disk_size       = var.worker-node-disk-size
  instance_types  = [var.worker-node-instance-type]
  tags            = merge({ Name = "${var.eks_cluster_name}-${var.environment}-private-node-group" }, tomap(var.additional_tags))

  remote_access {
    ec2_ssh_key = var.worker-node-ssh-key
  }

  scaling_config {
    desired_size = var.worker-node-desire-size
    max_size     = var.worker-node-max-size
    min_size     = var.worker-node-min-size
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}
