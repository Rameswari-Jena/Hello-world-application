provider "aws" {
  region = "us-east-1"
}

module "iam-for-lambda" {
  source       = "../../child-modules/IAM-for-lambda"
  project-name = var.project-name
}