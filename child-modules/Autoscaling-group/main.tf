provider "aws" {
  region = "us-east-1"
}

# Define remote state of load-balancer in data block , to use its output in launch-configuration & autoscaling configurations
data "terraform_remote_state" "load-balancer" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/load-balancer.tf"
  }
}

# Define remote state of IAM in data block , to use its output in launch-configuration & autoscaling configurations
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/iam.tf"
  }
}

# Define remote state of security groups in data block , to use its output in launch-configuration & autoscaling configurations
data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/security-group.tf"
  }
}

# Define remote state of Amazon AMI in data block , to use its output value in launch-configuration & autoscaling configurations
data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

### create launch configuration for web server ###
resource "aws_launch_configuration" "web-server-lc" {
  name_prefix   = "hello_world-web-lc"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  security_groups = [data.terraform_remote_state.security_group.outputs.security_group.web_security_group_id]
  iam_instance_profile = data.terraform_remote_state.iam.outputs.iam.instance_profile_arn
  user_data     = file("web_user_data.sh")

  lifecycle {
    create_before_destroy = false
  }
}

### create launch configuration for app server ###
resource "aws_launch_configuration" "app-server-lc" {
  name_prefix   = "hello_world-app-lc"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  associate_public_ip_address = false
  security_groups = [data.terraform_remote_state.security_group.outputs.security_group.app_security_group_id]
  iam_instance_profile = data.terraform_remote_state.iam.outputs.iam.instance_profile_arn
  user_data     = file("app_user_data.sh")

  lifecycle {
    create_before_destroy = false
  }
}

### Create web server ASG out of web server launch configuration ###
resource "aws_autoscaling_group" "web-asg" {
  name                      = "web-ASG"
  launch_configuration = aws_launch_configuration.web-server-lc.id
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [var.web_public_subnet_1, var.web_public_subnet_2]
  //load_balancers            = [data.terraform_remote_state.load-balancer.outputs.load_balancer.alb_arn]

  lifecycle {
    create_before_destroy = true
  }
}

### web asg aatachment with web target group ###

### web asg aatachment with ALB ###

### Create app server ASG out of app server launch configuration ###
resource "aws_autoscaling_group" "app-asg" {
  name                      = "app-ASG"
  launch_configuration = aws_launch_configuration.app-server-lc.id
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [var.app_private_subnet_1, var.app_private_subnet_2]
  //load_balancers            = [data.terraform_remote_state.load-balancer.outputs.load_balancer.alb_arn]

  lifecycle {
    create_before_destroy = true
  }
}

# Create a new load balancer attachment
/*resource "aws_autoscaling_attachment" "web_asg_attachment_with_alb" {
  autoscaling_group_name = aws_autoscaling_group.web-asg.id
  elb                    = data.terraform_remote_state.load-balancer.outputs.alb_arn
}*/

# Create a new ALB Target Group attachment
/*resource "aws_autoscaling_attachment" "web_asg_attachment_web_target_group" {
  autoscaling_group_name = aws_autoscaling_group.web-asg.id
  lb_target_group_arn    = data.terraform_remote_state.load-balancer.outputs.web_target_group_arn
}*/

# Create a new load balancer attachment
/*resource "aws_autoscaling_attachment" "app_asg_attachment_with_alb" {
  autoscaling_group_name = aws_autoscaling_group.app-asg.id
  elb                    = data.terraform_remote_state.load-balancer.outputs.load_balancer.alb_id
}*/

# Create an ALB app Target Group attachment with app ASG
resource "aws_autoscaling_attachment" "app_asg_attachment_app_target_group" {
  autoscaling_group_name = aws_autoscaling_group.app-asg.id
  lb_target_group_arn    = data.terraform_remote_state.load-balancer.outputs.load_balancer.app_target_group_arn
}
