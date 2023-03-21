provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "testvpc" {
  cidr_block = var.cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.testvpc.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-${element(var.availability_zones, count.index)}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.testvpc.id
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-${element(var.subnet_names, count.index)}-private-subnet"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.testvpc.id
  tags = {
    name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "test_RT" {
  vpc_id = aws_vpc.testvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
  tags = {
    name = "${var.vpc_name}-RT"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.test_RT.id
}