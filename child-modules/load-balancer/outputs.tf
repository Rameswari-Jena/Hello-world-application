# Define the variables of load-balancer, target group & listener which we want as outputs, to use it with other modules
output "alb_id" {
  value = aws_lb.alb.id
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

/*output "web_target_group_id" {
  value = aws_lb_target_group.web_target_group.id
}

output "web_target_group_arn" {
  value = aws_lb_target_group.web_target_group.arn
}*/

output "app_target_group_id" {
  value = aws_lb_target_group.app_target_group.id
}

output "app_target_group_arn" {
  value = aws_lb_target_group.app_target_group.arn
}

