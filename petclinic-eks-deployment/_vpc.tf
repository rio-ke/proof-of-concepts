resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name                                                               = "${var.eks_cluster_name}-${var.environment}-vpc"
    "kubernetes.io/cluster/${var.eks_cluster_name}-${var.environment}" = "shared"
  }
}

# Create the public subnet
resource "aws_subnet" "public_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}-${var.environment}" = "shared"
    "kubernetes.io/role/elb"                                           = 1
  }
  map_public_ip_on_launch = true
}

# Create IGW for the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

# Route the public subnet traffic through the IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.environment
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "internet_access" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.main.id
}

# Create the private subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = element(var.private_subnet_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}-${var.environment}" = "shared"
    "kubernetes.io/role/internal-elb"                                  = 1
  }
}

resource "aws_eip" "ps2" {
  vpc = true
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.ps1.id
  subnet_id     = aws_subnet.public_subnet.0.id
  tags          = merge({ Name = "${var.eks_cluster_name}-${var.environment}-nat-private-subnet-1" }, tomap(var.additional_tags))
}

resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private_subnet.0.id
  route_table_id = aws_route_table.nat-associations-1.id
  depends_on     = [aws_nat_gateway.nat1]
}

resource "aws_route_table" "nat-associations-1" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
  depends_on = [aws_route_table.nat-associations-1]
}

resource "aws_eip" "ps1" {
  vpc = true
}
resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.ps2.id
  subnet_id     = aws_subnet.public_subnet.1.id
  tags          = merge({ Name = "${var.eks_cluster_name}-${var.environment}-nat-private-subnet-2" }, tomap(var.additional_tags))
}
resource "aws_route_table" "nat-associations-2" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat2.id
  }
  depends_on = [aws_route_table.nat-associations-2]
}

resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private_subnet.1.id
  route_table_id = aws_route_table.nat-associations-2.id
  depends_on     = [aws_nat_gateway.nat2]
}
