resource "aws_ecs_service" "ecs_always_on_service" {
  count           = var.always_on ? 1 : 0
  name            = "${var.name_prefix}ECSService-${random_id.suffix.dec}"
  desired_count   = 1
  cluster         = data.aws_ecs_cluster.ecs_cluster.arn
  task_definition = aws_ecs_task_definition.ecs_task.arn
  launch_type     = local.launch_type
  # iam_role        = aws_iam_role.ecs_execution_role.name
  depends_on = [aws_lb.alb]
  network_configuration {
    subnets          = local.subnets
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = true
  }
  dynamic "load_balancer" {
    for_each = var.use_load_balancer ? toset(var.app_ports) : []
    content {
      target_group_arn = var.use_load_balancer ? aws_lb_target_group.alb_target_group[load_balancer.value].arn : null
      container_name   = var.container_name
      container_port   = load_balancer.value
      # container_name = var.use_load_balancer ? var.container_name : null
      # container_port = var.use_load_balancer ? var.admin_ports["WebPortal"] : null
    }
  }
}
