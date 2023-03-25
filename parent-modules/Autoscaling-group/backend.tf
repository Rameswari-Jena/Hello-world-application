terraform {
  backend "s3" {
    bucket = "assignment-bucket-1991"
    key    = "state/asg.tf"
    region = "us-east-1"
  }
}
