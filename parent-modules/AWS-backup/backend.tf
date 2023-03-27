terraform {
  backend "s3" {
    bucket = "assignment-bucket-1991"
    key    = "state/aws-backup.tf"
    region = "us-east-1"
  }
}
