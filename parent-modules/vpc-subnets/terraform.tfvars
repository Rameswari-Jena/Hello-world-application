project-name               = "hello-world"
vpc-cidr                   = "10.0.0.0/16"
availability_zones         = ["us-east-1a", "us-east-1b"]
private_subnets_cidr       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
public_subnets_cidr        = ["10.0.101.0/24", "10.0.102.0/24"]
public_subnet_names        = ["web"]
us-east-1a-private-subnets = ["subnet-098f21ec5b9f7f82e", "subnet-0fc023130096b3e89"]
us-east-1b-private-subnets = ["subnet-05cd9fb1782d7bfc5", "subnet-07558909f5f8a8434"]

