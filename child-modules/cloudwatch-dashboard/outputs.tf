output "app-asg-dashboard" {
  value = aws_cloudwatch_dashboard.app-asg-performance.id
}

output "web-asg-dashboard" {
  value = aws_cloudwatch_dashboard.web-asg-performance.id
}


