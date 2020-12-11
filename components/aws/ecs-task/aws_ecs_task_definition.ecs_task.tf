resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.name_prefix}Task-${random_id.suffix.dec}"
  network_mode             = local.network_mode
  requires_compatibilities = [local.launch_type]
  cpu                      = var.container_num_cores * 1024
  memory                   = var.container_ram_gb * 1024
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  tags                     = var.common_tags
  container_definitions    = <<DEFINITION
[
  {
    "name":       var.container_name,
    "image":      "${var.container_image}",
    "cpu":         ${var.container_num_cores * 1024},
    "memory":      ${var.container_ram_gb * 1024},
    ${local.entrypoint_str}
    ${local.command_str}
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group":          "${aws_cloudwatch_log_group.cw_log_group.name}",
        "awslogs-region":         "${var.environment.aws_region}",
        "awslogs-stream-prefix":  "container-log"
      }
    },
    "portMappings": [
      {
        "containerPort": ${var.app_ports[0]},
        "hostPort":      ${var.app_ports[0]},
        "protocol":      "tcp"
      }
    ],
    "environment": [
      ${local.container_env_vars_str}
    ],
    "secrets": [
      ${local.container_secrets_str}
    ],
    "mountPoints": [],
    "volumesFrom": [],
    "essential" : true
  }
]
DEFINITION
}
