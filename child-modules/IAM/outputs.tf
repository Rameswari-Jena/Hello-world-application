# Define the variables of instance profile which we want as outputs, to use it with other modules
output "instance_profile_id" {
  value = aws_iam_instance_profile.ec2-ssm-iam-profile.id
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.ec2-ssm-iam-profile.arn
}