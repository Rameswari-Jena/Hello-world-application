terraform {
  backend "s3" {
    bucket = "assignment-bucket-1991"
    key    = "state/nat-gateway.tf"
    region = "us-east-1"
  }
}
