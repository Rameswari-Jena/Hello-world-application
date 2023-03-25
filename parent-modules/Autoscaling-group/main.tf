provider "aws" {
  region = "us-east-1"
}

module "asg" {
  source               = "../../child-modules/Autoscaling-group"
  web_public_subnet_1  = var.web_public_subnet_1
  web_public_subnet_2  = var.web_public_subnet_2
  app_private_subnet_1 = var.app_private_subnet_1
  app_private_subnet_2 = var.app_private_subnet_2
}