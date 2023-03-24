provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "vpc-subnets" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/vpc-subnets.tf"
  }
}

###load balancer security group ###
resource "aws_security_group" "lb_sg" {
  name        = "${var.security_group_name}-lb_sg"
  description = "hello-world-lb-sg"
  vpc_id      = data.terraform_remote_state.vpc-subnets.outputs.vpc.vpc_id
  tags = {
    Name = "internal-alb-sg"
  }
}

### web server security group ###
resource "aws_security_group" "web_sg" {
  name        = "${var.security_group_name}-web-sg"
  description = "hello-world-web-sg"
  vpc_id      = data.terraform_remote_state.vpc-subnets.outputs.vpc.vpc_id
  tags = {
    Name = "web-sg"
  }
}

### app server security group ###
resource "aws_security_group" "app_sg" {
  name        = "${var.security_group_name}-app-sg"
  description = "hello-world-app-sg"
  vpc_id      = data.terraform_remote_state.vpc-subnets.outputs.vpc.vpc_id
  tags = {
    Name = "app-sg"
  }
}

### database server security group ###
resource "aws_security_group" "database_sg" {
  name        = "${var.security_group_name}-database-sg"
  description = "hello-world-database-sg"
  vpc_id      = data.terraform_remote_state.vpc-subnets.outputs.vpc.vpc_id
  tags = {
    Name = "database-sg"
  }
}

###load balancer security group rules ###

resource "aws_security_group_rule" "vpc-to-lb-https-ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = [var.vpc_cidr_block]
}

resource "aws_security_group_rule" "vpc-to-lb-http-ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = [var.vpc_cidr_block]
}

/*resource "aws_security_group_rule" "vpc-to-lb-ssh-ingress" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.lb_sg.id
    cidr_blocks = [data.terraform_remote_state.vpc.testvpc.cidr_block]
}*/

resource "aws_security_group_rule" "lb-to-vpc-https-egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = [var.vpc_cidr_block]
}

resource "aws_security_group_rule" "lb-to-vpc-http-egress" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = [var.vpc_cidr_block]
}

resource "aws_security_group_rule" "lb-to-web-server-https-egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "lb-to-web-server-http-egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

###---------------------------------------------------------------------###
### web server security group rule ###
resource "aws_security_group_rule" "lb-to-web-https-ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "lb-to-web-http-ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "web-to-lb-https-egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "web-to-lb-http-engress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "web-to-app-https-engress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "web-to-app-http-engress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "web-to-app-ssh-engress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}
###------------------------------------------------------------------------###
### app server security group rule ###

resource "aws_security_group_rule" "web-to-app-https-ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web-to-app-http-ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web-to-app-ssh-ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "database-to-app-mysql-ingress" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "app-to-web-https-egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "app-to-web-http-egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "app-to-web-ssh-egress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "app-to-database-mysql-egress" {
  type                     = "egress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.database_sg.id
}

###-----------------------------------------------------------------------###

### database server security group rule ###

resource "aws_security_group_rule" "app-to-database-mysql-ingress" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "database-to-app-mysql-egress" {
  type                     = "egress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}



