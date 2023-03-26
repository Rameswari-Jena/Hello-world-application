# Define variables required to create the lambda-functions
variable "project-name" {
  type        = string
  description = "name of lambda function takes the name of the project"
}

variable "aws_region" {
  type        = string
  description = "name of the region to create lambda function"
}