variable "vpc_name" {
  type        = string
  description = "name of the vpc"
}

variable "cidr" {
  type        = string
  description = "cidr of vpc"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
}

variable "private_subnets" {
  type        = list(string)
  description = "private subnet's cidr range"
}

variable "public_subnets" {
  type        = list(string)
  description = "public subnet's cidr range"
}

variable "subnet_names" {
  type        = list(string)
  description = "name of private subnets"
}