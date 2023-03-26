output "lambda_function_1_name" {
  value = aws_lambda_function.hello_world_lambda_stop_ec2.function_name
}

# Define the variables of lambda functions which we want as outputs, to use it with other modules

output "lambda_function_1_id" {
  value = aws_lambda_function.hello_world_lambda_stop_ec2.id
}

output "lambda_function_1_arn" {
  value = aws_lambda_function.hello_world_lambda_stop_ec2.qualified_arn
}

output "lambda_function_2_name" {
  value = aws_lambda_function.hello_world_lambda_start_ec2.function_name
}

output "lambda_function_2_id" {
  value = aws_lambda_function.hello_world_lambda_start_ec2.id
}

output "lambda_function_2_arn" {
  value = aws_lambda_function.hello_world_lambda_start_ec2.qualified_arn
}