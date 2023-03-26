# Define variables required to create the launch_configuration & autoscaling group
variable "web_public_subnet_1" {
  type        = string
  description = "id of web public subnet 1"
}

variable "web_public_subnet_2" {
  type        = string
  description = "id of web public subnet 2"
}

variable "app_private_subnet_1" {
  type        = string
  description = "id of app private subnet 1"
}

variable "app_private_subnet_2" {
  type        = string
  description = "id of app private subnet 2"
}