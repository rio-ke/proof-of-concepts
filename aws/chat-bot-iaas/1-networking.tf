# Internet VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags                 = merge(map("Name", "${var.project}-vpc"), var.additional_tags)
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"
  tags                    = merge(map("Name", "vpc-public-subnet"), var.additional_tags)
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-subnet-1
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"
  tags                    = merge(map("Name", "vpc-public-subnet"), var.additional_tags)
}


# Internet GW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(map("Name", "${var.project}-vpc-gw"), var.additional_tags)
}

# Route tables
resource "aws_default_route_table" "rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(map("Name", "${var.project}-public-vpc-rt"), var.additional_tags)
}


resource "aws_route_table_association" "public-subnet" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_vpc.vpc.default_route_table_id
}

resource "aws_route_table_association" "public-subnet-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_vpc.vpc.default_route_table_id
}


resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_1
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"
  tags                    = merge(map("Name", "${var.project}-vpc-private-subnet-1"), var.additional_tags)
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_2
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"
  tags                    = merge(map("Name", "${var.project}-vpc-private-subnet-2"), var.additional_tags)
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet.id
}

resource "aws_route_table" "rt-nat" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(map("Name", "${var.project}-nat-vpc-gw"), var.additional_tags)
  depends_on             = [aws_nat_gateway.nat]

}

resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.rt-nat.id
  depends_on             = [aws_route_table.rt-nat]

}

resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.rt-nat.id
  depends_on             = [aws_route_table.rt-nat]
}

