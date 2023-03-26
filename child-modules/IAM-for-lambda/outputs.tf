# Define the variables of iam role & policy for lambda, which we want as outputs, to use it with other modules
output "lambda-role-id" {
  value = aws_iam_role.lambda-role.id
}

output "lambda-role-arn" {
  value = aws_iam_role.lambda-role.arn
}

