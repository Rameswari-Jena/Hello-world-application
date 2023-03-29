provider "aws" {
  region = "us-east-1"
}

module "nat-gateway" {
  source          = "../../child-modules/nat-gateway"
  public-subnet-1 = var.public-subnet-1
  public-subnet-2 = var.public-subnet-2
}