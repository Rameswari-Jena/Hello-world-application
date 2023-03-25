provider "aws" {
  region = "us-east-1"
}

module "load_balancer" {
  source = "../../child-modules/load-balancer"
  project-name = var.project-name
  app_private_subnets_1 = var.app_private_subnets_1
  app_private_subnets_2 = var.app_private_subnets_2
}