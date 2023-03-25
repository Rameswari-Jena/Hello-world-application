output "web-asg-id" {
  value = aws_autoscaling_group.web-asg.id
}

output "app-asg-id" {
  value = aws_autoscaling_group.app-asg.id
}