# Define the variables of vpc endpoint which we want as outputs, to use it with other modules

output "vpc-endpoint-ssm-id" {
  value = aws_vpc_endpoint.ssm.id
}

output "vpc-endpoint-ssm-arn" {
  value = aws_vpc_endpoint.ssm.arn
}

/*output "vpc-endpoint-ssm-agent-to-ssm-id" {
  value = aws_vpc_endpoint.ssm-agent-to-ssm.id
}

output "vpc-endpoint-ssm-agent-to-ssm-arn" {
  value = aws_vpc_endpoint.ssm-agent-to-ssm.arn
}

output "vpc-endpoint-session-manager-id" {
  value = aws_vpc_endpoint.session-manager.id
}

output "vpc-endpoint-session-manager-arn" {
  value = aws_vpc_endpoint.session-manager.arn
}*/
