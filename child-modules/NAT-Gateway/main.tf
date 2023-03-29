data "terraform_remote_state" "vpc-subnets" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/vpc-subnets.tf"
  }
}

resource "aws_eip" "eip-1" {
  vpc = true
}

resource "aws_eip" "eip-2" {
  vpc = true
}

resource "aws_nat_gateway" "nat-for-us-east-1a" {
  allocation_id = aws_eip.eip-1.id
  subnet_id         = var.public-subnet-1
  connectivity_type = "public"

  tags = {
    Name = "us-east-1A"
  }
}

resource "aws_nat_gateway" "nat-for-us-east-1b" {
  allocation_id = aws_eip.eip-2.id
  subnet_id         = var.public-subnet-2
  connectivity_type = "public"

  tags = {
    Name = "us-east-1B"
  }
}