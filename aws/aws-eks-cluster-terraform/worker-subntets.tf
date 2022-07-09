# # Nodes in private subnets
# resource "aws_eks_node_group" "main" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = var.node_group_name
#   node_role_arn   = aws_iam_role.eks_nodes.arn
#   subnet_ids      = [aws_subnet.private_subnet.id]
#   ami_type       = "AL2_x86_64"
#   disk_size      = 20
#   instance_types = ["t3.medium"]
#   scaling_config {
#     desired_size = 1
#     max_size     = 1
#     min_size     = 1
#       }
#   tags = {
#     Name = var.node_group_name
#   }
  
#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
#     aws_iam_role_policy_attachment.aws_eks_cni_policy,
#     aws_iam_role_policy_attachment.ec2_read_only,
#   ]
# }



# Nodes in public subnet
resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.node_group_name}-public"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = flatten([aws_subnet.public_subnet.*.id])
  ami_type       = "AL2_x86_64"
  disk_size      = 20
  instance_types = ["t3.medium"]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
      }
  tags = {
    Name = "${var.node_group_name}-public"
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
  ]
}