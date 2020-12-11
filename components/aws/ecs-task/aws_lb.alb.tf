resource "aws_lb" "alb" {
  count              = var.use_load_balancer ? 1 : 0
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = coalesce(var.environment.public_subnets, var.environment.private_subnets)
  tags               = var.common_tags
  security_groups    = [aws_security_group.ecs_tasks_sg.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = var.lb_logs_bucket
    prefix  = "ecs-task-test-lb"
    enabled = true
  }

}
