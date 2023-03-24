provider "aws" {
  region = "us-east-1"
}

module "security_group" {
  source       = "../../child-modules/security-group"
  project-name = var.project-name
  vpc_cidr     = var.vpc_cidr
}