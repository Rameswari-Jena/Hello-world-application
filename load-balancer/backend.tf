terraform {
  backend "s3" {
    bucket = "assignment-bucket-1991"
    key    = "state/load-balancer.tf"
    region = "us-east-1"
  }
}
