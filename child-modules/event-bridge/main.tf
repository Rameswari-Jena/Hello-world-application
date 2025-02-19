# Define remote state of lambda-function in data block , to use its output in event bridge configurations
data "terraform_remote_state" "lambda-function" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/lambda.tf"
  }
}

#create event bridge rule to schedule cron for the cloud watch to trigger lambda function to stop the running EC2 instances
resource "aws_cloudwatch_event_rule" "schedule_to_stop_ec2" {
  name                = "schedule_to_stop_ec2"
  description         = "Schedule for Lambda Function to get executed"
  schedule_expression = var.schedule_to_stop_ec2
}

#create event bridge rule to schedule cron for the cloud watch to trigger lambda function to start the stopped EC2 instances
resource "aws_cloudwatch_event_rule" "schedule_to_start_ec2" {
  name                = "schedule_to_start_ec2"
  description         = "Schedule for Lambda Function to get executed"
  schedule_expression = var.schedule_to_start_ec2
}

#create event bridge target as lambda function for stopping and starting the EC2 instances
resource "aws_cloudwatch_event_target" "schedule_lambda_to_stop_ec2" {
  rule      = aws_cloudwatch_event_rule.schedule_to_stop_ec2.name
  target_id = "hello-world-lambda_stop_ec2"
  arn       = data.terraform_remote_state.lambda-function.outputs.lambda.lambda_function_1_arn
}

resource "aws_cloudwatch_event_target" "schedule_lambda_to_start_ec2" {
  rule      = aws_cloudwatch_event_rule.schedule_to_start_ec2.name
  target_id = "hello-world-lambda_start_ec2"
  arn       = data.terraform_remote_state.lambda-function.outputs.lambda.lambda_function_2_arn
}

# create lambda permission to allow cloud watch event to invoke lambda functions at scheduled cron timings
resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda_to_stop_ec2" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.lambda-function.outputs.lambda.lambda_function_1_name
  principal     = "events.amazonaws.com"
}

resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda_to_start_ec2" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.lambda-function.outputs.lambda.lambda_function_2_name
  principal     = "events.amazonaws.com"
}