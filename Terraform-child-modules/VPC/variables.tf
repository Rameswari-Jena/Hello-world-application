variable "vpc_name" {
  type        = string
  description = "name of the vpc"
}

variable "cidr" {
  type        = string
  description = "Autodesk Product"
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