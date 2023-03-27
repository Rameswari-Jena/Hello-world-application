provider "aws" {
  region = "us-east-1"
}

module "cloudwatch-dashboard" {
  source       = "../../child-modules/cloudwatch-dashboard"
  project-name = var.project-name
}