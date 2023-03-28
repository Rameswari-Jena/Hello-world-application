data "terraform_remote_state" "security-group" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/security-group.tf"
  }
}

data "terraform_remote_state" "vpc-subnets" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/vpc-subnets.tf"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/iam.tf"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = data.terraform_remote_state.vpc-subnets.outputs.vpc.vpc_id
  service_name = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids    = ["subnet-098f21ec5b9f7f82e", "subnet-05cd9fb1782d7bfc5"]
  security_group_ids = [
    data.terraform_remote_state.security-group.outputs.security_group.alb_security_group_id
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm-agent-to-ssm" {
  vpc_id       = data.terraform_remote_state.vpc-subnets.outputs.vpc.vpc_id
  service_name = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids    = ["subnet-098f21ec5b9f7f82e", "subnet-05cd9fb1782d7bfc5"]
  security_group_ids = [
    data.terraform_remote_state.security-group.outputs.security_group.alb_security_group_id
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "session-manager" {
  vpc_id       = data.terraform_remote_state.vpc-subnets.outputs.vpc.vpc_id
  service_name = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids    = ["subnet-098f21ec5b9f7f82e", "subnet-05cd9fb1782d7bfc5"]
  security_group_ids = [
    data.terraform_remote_state.security-group.outputs.security_group.alb_security_group_id
  ]
  private_dns_enabled = true
}