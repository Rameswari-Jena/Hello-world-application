provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source       = "../../child-modules/IAM"
  project-name = var.project-name
}