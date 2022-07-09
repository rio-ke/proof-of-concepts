region = "us-east-1"
eks_cluster_name = "democlst"
environment = "dev"
cluster_sg_name = "democlst-sg"
vpc_cidr_block = "10.0.0.0/16"
vpc_tag_name = "vpc-tag"
private_subnet_cidr_block = "10.0.1.0/24"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
node_group_name = "democlst-group"


# aws eks --region us-east-1 update-kubeconfig --name democlst