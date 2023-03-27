provider "aws" {
  region = "us-east-1"
}

module "aws-backup" {
  source       = "../../child-modules/AWS-backup"
  project-name = var.project-name
  schedule     = var.schedule
}