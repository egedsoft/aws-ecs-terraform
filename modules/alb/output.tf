output "aws_alb_listener" {
  value = aws_alb_listener.testapp
}

output "aws_target_group_arn" {
  value = aws_alb_target_group.app-tg.arn
}

output "dns_name" {
  value       = aws_alb.alb.dns_name
  description = "description"
}