# Define all the variables to create vpc endpoint for establishing connection between SSM and EC2 instances
variable "project-name" {
  type        = string
  description = "name of the vpc enpoint takes the name of the project"
}