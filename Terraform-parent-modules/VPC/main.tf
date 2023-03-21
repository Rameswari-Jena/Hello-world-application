module "vpc" {
  source = "git@github.com:Rameswari-Jena/Hello-world-application.git//Terraform-child-modules/VPC/"
}

resource "aws_vpc" "hello-world" {
  vpc_name             = var.vpc_name
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "hello-world-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "var.vpc_name-igw"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-${element(var.availability_zones, count.index)}-public-subnet"
  }
}


# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-${element(var.availability_zones, count.index)}-private-subnet"
  }
}
