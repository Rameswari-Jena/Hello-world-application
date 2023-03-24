output "alb_security_group_id" {
  value = aws_security_group.lb_sg.id
}

output "web_security_group_id" {
  value = aws_security_group.web_sg.id
}

output "app_security_group_id" {
  value = aws_security_group.app_sg.id
}

output "database_security_group_id" {
  value = aws_security_group.database_sg.id
}