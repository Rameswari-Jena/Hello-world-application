# Define variables required to create the load balancer,target group & listener
variable "project-name" {
  type        = string
  description = "name of the load balancer takes the name of the project"
}

variable "app_private_subnets_1" {
  type        = string
  description = "id of any of the private subnet, to keep internal alb in it"
}

variable "app_private_subnets_2" {
  type        = string
  description = "id of any of the private subnet, to keep internal alb in it"
}