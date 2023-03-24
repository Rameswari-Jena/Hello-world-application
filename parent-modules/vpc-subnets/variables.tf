variable "project-name" {
  type        = string
  description = "name of the vpc will be name of the project"
}

variable "vpc-cidr" {
  type        = string
  description = "cidr of vpc"
}

variable "availability_zones" {
  type        = list(string)
  description = "list of availability zones"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "private subnet's cidr range"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "public subnet's cidr range"
}

variable "public_subnet_names" {
  type        = list(string)
  description = "name of public subnets"
}

variable "private_subnet_names" {
  type        = list(string)
  description = "name of private subnets"
}