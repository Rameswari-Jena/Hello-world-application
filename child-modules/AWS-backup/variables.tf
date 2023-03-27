# Define all the variables to aws backup plan and vault
variable "project-name" {
  type        = string
  description = "aws backup plan name takes the name of project name"
}

variable "schedule" {
  type        = string
  description = "schedule to take backup"
}