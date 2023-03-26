data "terraform_remote_state" "iam-for-lambda" {
  backend = "s3"
  config = {
    region = "us-east-1"
    bucket = "assignment-bucket-1991"
    key    = "state/iam-for-lambda.tf"
  }
}

data "archive_file" "function-1" {
  type        = "zip"
  source_file = "stop_instances.py"
  output_path = "stop_instances.zip"
}

data "archive_file" "function-2" {
  type        = "zip"
  source_file = "start_instances.py"
  output_path = "start_instances.zip"
}

resource "aws_lambda_function" "hello_world_lambda_stop_ec2" {
  function_name = "${var.project-name}-lambda_stop_ec2"
  filename         = data.archive_file.function-1.output_path
  source_code_hash = data.archive_file.function-1.output_base64sha256
  role          = data.terraform_remote_state.iam-for-lambda.outputs.iam-for-lambda.lambda-role-arn
  handler       = "stop_instances.lambda_handler"
  runtime       = "python3.8"

  ephemeral_storage {
    size = 10240 
  }
}

resource "aws_lambda_function" "hello_world_lambda_start_ec2" {
  function_name = "${var.project-name}-lambda_start_ec2"
  filename         = data.archive_file.function-2.output_path
  source_code_hash = data.archive_file.function-2.output_base64sha256
  role          = data.terraform_remote_state.iam-for-lambda.outputs.iam-for-lambda.lambda-role-arn
  handler       = "start_instances.lambda_handler"
  runtime       = "python3.8"

  ephemeral_storage {
    size = 10240 
  }
}