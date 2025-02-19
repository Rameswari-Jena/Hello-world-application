provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source                     = "../../child-modules/vpc-subnets"
  project-name               = var.project-name
  vpc-cidr                   = var.vpc-cidr
  availability_zones         = var.availability_zones
  private_subnets_cidr       = var.private_subnets_cidr
  public_subnets_cidr        = var.public_subnets_cidr
  public_subnet_names        = var.public_subnet_names
  us-east-1a-private-subnets = var.us-east-1a-private-subnets
  us-east-1b-private-subnets = var.us-east-1b-private-subnets
}
