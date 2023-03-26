provider "aws" {
  region = "us-east-1"
}

module "lambda" {
  source       = "../../child-modules/lambda-function"
  project-name = var.project-name
  aws_region   = var.aws_region
}