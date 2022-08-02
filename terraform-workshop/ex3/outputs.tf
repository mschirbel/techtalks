output "alb_dns" {
  value = aws_lb.autoscaling_group_alb.dns_name
}
