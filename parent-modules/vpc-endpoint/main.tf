provider "aws" {
  region = "us-east-1"
}

module "vpc-endpoint" {
  source       = "../../child-modules/vpc-endpoint"
  project-name = var.project-name
}