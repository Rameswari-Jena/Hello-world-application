provider "aws" {
  region = "us-east-1"
}

module "event-bridge" {
  source                = "../../child-modules/event-bridge"
  schedule_to_stop_ec2  = var.schedule_to_stop_ec2
  schedule_to_start_ec2 = var.schedule_to_start_ec2
}