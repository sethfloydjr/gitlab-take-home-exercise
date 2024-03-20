resource "aws_route53_record" "route53" {
  zone_id = var.r53_zone_id
  name    = "web"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.lb.dns_name]
}
