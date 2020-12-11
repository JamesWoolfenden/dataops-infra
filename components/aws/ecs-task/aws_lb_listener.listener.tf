
resource "aws_lb_listener" "listener" {
  for_each          = var.use_load_balancer ? toset(var.app_ports) : []
  load_balancer_arn = aws_lb.alb[0].arn
  port              = each.value
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group[each.value].arn
  }
}
