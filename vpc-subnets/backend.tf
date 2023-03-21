terraform {
  backend "s3" {
    bucket = "assignment-bucket-1991"
    key    = "state/vpc-subnets.tf"
    region = "us-east-1"
  }
}
