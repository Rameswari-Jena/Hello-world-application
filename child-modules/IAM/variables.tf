# Define variables required to create the IAM role for EC2 to get managed by SSM
variable "project-name" {
  type        = string
  description = "name of the role takes the name of the project"
}