variable "alb_name" {
  type        = string
  description = "name of the load balancer"
}

variable "private_subnets_1" {
  type        = string
  description = "id of any of the private subnet, to keep internal alb in it"
}

variable "private_subnets_2" {
  type        = string
  description = "id of any of the private subnet, to keep internal alb in it"
}