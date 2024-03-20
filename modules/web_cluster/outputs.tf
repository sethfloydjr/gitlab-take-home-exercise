output "web_lb_dns_name" {
  description = "The DNS record name for LB"
  value       = aws_lb.lb.dns_name
}
