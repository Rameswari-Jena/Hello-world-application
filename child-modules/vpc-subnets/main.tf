
#create non-default vpc
resource "aws_vpc" "testvpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project-name}-vpc"
  }
}

data "terraform_remote_state" "nat-gateway" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/nat-gateway.tf"
  }
}

#create non-default public subnets for web tier
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.testvpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project-name}-${element(var.public_subnet_names, count.index)}-public-subnet"
  }
}

#create non-default private subnets for app & database tier
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.testvpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project-name}-${element(var.availability_zones, count.index)}-private-subnet"
  }
}

#create internet gateway to attach with non-default vpc
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.testvpc.id
  tags = {
    name = "${var.project-name}-igw"
  }
}

#create route table for public subnet routing
resource "aws_route_table" "test_RT" {
  vpc_id = aws_vpc.testvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
  tags = {
    name = "${var.project-name}-RT"
  }
}

# associate public subnets to the above created route table to pass traffic through igw to public subnets to connect to web server
resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.test_RT.id
}

#------------------------------------------------------------------------------------------------------------------------
#create route table for private subnet from us-east-1a AZ routing

resource "aws_route_table" "us-east-1a_RT" {
  vpc_id = aws_vpc.testvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.terraform_remote_state.nat-gateway.outputs.nat-gateway.nat-for-us-east-1a-id
  }
  tags = {
    name = "${var.project-name}-US-EAST-1A-RT"
  }
}

# associate nat gateway to the above RT to allow private instances from us-east-1b AZ to internet to install web server
resource "aws_route_table_association" "private_route_association-us-east-1a" {
  count = length(var.us-east-1a-private-subnets)
  subnet_id      = var.us-east-1a-private-subnets[count.index]
  route_table_id = aws_route_table.us-east-1a_RT.id
}

#------------------------------------------------------------------------------------------------------------------------
#create route table for private subnet from us-east-1b AZ routing

resource "aws_route_table" "us-east-1b_RT" {
  vpc_id = aws_vpc.testvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.terraform_remote_state.nat-gateway.outputs.nat-gateway.nat-for-us-east-1b-id
  }
  tags = {
    name = "${var.project-name}-US-EAST-1B-RT"
  }
}

# associate nat gateway to the above RT to allow private instances from us-east-1b AZ to internet to install web server
resource "aws_route_table_association" "private_route_association-us-east-1b" {
  count = length(var.us-east-1a-private-subnets)
  subnet_id      = var.us-east-1b-private-subnets[count.index]
  route_table_id = aws_route_table.us-east-1b_RT.id
}