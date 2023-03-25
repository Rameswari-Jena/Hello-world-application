resource "aws_iam_role" "ec2-ssm-iam-role" {
  name               = "${var.project-name}-ec2-ssm-iam-role"
  description        = "role for the EC2 to get managed by SSM"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": {
  "Effect": "Allow",
  "Principal": {"Service": "ec2.amazonaws.com"},
  "Action": "sts:AssumeRole"
  }
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "ec2-ssm-iam-policy" {
  role       = aws_iam_role.ec2-ssm-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2-ssm-iam-profile" {
  name = "${var.project-name}_ec2_profile"
  role = aws_iam_role.ec2-ssm-iam-role.name
}


