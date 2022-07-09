# Internet VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.project}-vpc-subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.project}-vpc-subnet-2"
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "${var.project}-vpc-subnet-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-vpc-gw"
  }
}

# Route tables
resource "aws_default_route_table" "rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.project}-vpc-rt"
  }
}

resource "aws_route_table_association" "subnet-1" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_vpc.vpc.default_route_table_id
}

resource "aws_route_table_association" "subnet-2" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_vpc.vpc.default_route_table_id
}


resource "aws_route_table_association" "subnet-3" {
  subnet_id      = aws_subnet.subnet-3.id
  route_table_id = aws_vpc.vpc.default_route_table_id
}
