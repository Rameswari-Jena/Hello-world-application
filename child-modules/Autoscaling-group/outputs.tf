# Define the variables of launch_configuration & autoscaling group which we want as outputs, to use it with other modules

output "web-asg-id" {
  value = aws_autoscaling_group.web-asg.id
}

output "app-asg-id" {
  value = aws_autoscaling_group.app-asg.id
}