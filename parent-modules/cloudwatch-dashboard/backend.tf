terraform {
  backend "s3" {
    bucket = "assignment-bucket-1991"
    key    = "state/cloudwatch-dashboard.tf"
    region = "us-east-1"
  }
}
