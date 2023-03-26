data "terraform_remote_state" "lambda-function" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/lambda.tf"
  }
}

resource "aws_cloudwatch_event_rule" "schedule_to_stop_ec2" {
  name                = "schedule_to_stop_ec2"
  description         = "Schedule for Lambda Function to get executed"
  schedule_expression = var.schedule_to_stop_ec2
}

resource "aws_cloudwatch_event_rule" "schedule_to_start_ec2" {
  name                = "schedule_to_start_ec2"
  description         = "Schedule for Lambda Function to get executed"
  schedule_expression = var.schedule_to_start_ec2
}

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