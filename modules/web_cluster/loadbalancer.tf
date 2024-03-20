resource "aws_lb" "lb" {
  name                       = "web-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [var.public_subnets[0], var.public_subnets[1], var.public_subnets[2]]
  enable_deletion_protection = true
  security_groups            = [aws_security_group.web_lb_sg.id]
}

resource "aws_lb_listener" "LB_Forward_443" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = var.acm_cert_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LB_Forward_TG_443.arn
  }
}


resource "aws_lb_listener" "LB_REDIRECT_80" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}

resource "aws_lb_target_group" "LB_Forward_TG_443" {
  name     = "LB-Forward-TG-443"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  health_check {
    protocol = "HTTPS"
    path     = "/"
    matcher  = "302"
  }
}
