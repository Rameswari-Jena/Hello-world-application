#create IAM policy for lambda role, permitting few operations on Ec2 and cloudwatch

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.project-name}-lambda-policy"
  description = "Enable Lambda to access few operations on EC2 & cloudwatch"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:Start*",
          "ec2:Stop*",
          "ec2:DescribeInstanceStatus"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

#create IAM role for lambda to access EC2 & cloud watch
resource "aws_iam_role" "lambda-role" {
  name               = "${var.project-name}-lambda-role"
  description        = "role for the Lambda to access EC2 & cloudwatch"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "lambda.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
  }
  EOF
}

# attach created lambda policy with lambda role
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# attach EC2 read policy with lambda role to allow lambda to describe instance for carrying out starting & stopping Ec2 instance
resource "aws_iam_role_policy_attachment" "lambda-ec2-read-policy-attachment" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

