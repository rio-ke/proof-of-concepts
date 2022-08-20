resource "aws_vpc" "av" {
  cidr_block = var.VPC_CIDR_BLOCK
  tags = {
    Name = "${var.PROJECT}-${var.ENVIRONMENT}-vpc"
  }
}

resource "aws_subnet" "as" {
  vpc_id                  = aws_vpc.av.id
  cidr_block              = var.SUBNET_CIDR_BLOCK
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT}-${var.ENVIRONMENT}-subnet"
  }
}

resource "aws_internet_gateway" "aig" {
  vpc_id = aws_vpc.av.id

  tags = {
    Name = "${var.PROJECT}-${var.ENVIRONMENT}-aig"
  }
}

resource "aws_route_table" "art" {
  vpc_id = aws_vpc.av.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aig.id
  }

  tags = {
    Name = "${var.PROJECT}-${var.ENVIRONMENT}-art"
  }
}

resource "aws_route_table_association" "arta" {
  subnet_id      = aws_subnet.as.id
  route_table_id = aws_route_table.art.id
}
