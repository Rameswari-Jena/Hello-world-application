terraform {
  backend "s3" {
    bucket = "assignment-bucket-1991"
    key    = "state/iam-for-lambda.tf"
    region = "us-east-1"
  }
}
