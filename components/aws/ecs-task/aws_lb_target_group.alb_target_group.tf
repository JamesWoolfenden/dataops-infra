

resource "aws_lb_target_group" "alb_target_group" {
  for_each    = var.use_load_balancer ? toset(var.app_ports) : []
  name        = "${var.name_prefix}LBTargets-${each.value}"
  port        = each.value
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.environment.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 10
    path                = "/admin/"
    interval            = 30
    matcher             = "200,302"
  }
}
