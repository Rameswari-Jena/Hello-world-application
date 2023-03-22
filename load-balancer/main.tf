provider "aws" {
  region = "us-east-1"
}

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

resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.security-group.outputs.alb_security_group_id]
  subnets             = [var.private_subnets_1, var.private_subnets_2]

  enable_deletion_protection = true

  tags = {
    Name = "Hello-world-LB"
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name        = "web-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc-subnets.outputs.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "app_target_group" {
  name        = "app-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc-subnets.outputs.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

### create a listener on port 80 with fixed response action ###
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello World"
      status_code  = "200"
    }
  }
}
