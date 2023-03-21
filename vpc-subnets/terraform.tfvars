vpc_name           = "hello-world"
cidr               = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
subnet_names       = ["web", "app", "database"]
public_subnets     = ["10.0.101.0/24"]

