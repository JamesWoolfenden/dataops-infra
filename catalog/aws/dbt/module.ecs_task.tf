

module "ecs_task" {
  source              = "../../../components/aws/ecs-task"
  name_prefix         = "${local.name_prefix}run-"
  environment         = var.environment
  common_tags         = var.common_tags
  ecs_cluster_name    = module.ecs_cluster.ecs_cluster_name
  container_image     = var.container_image
  container_ram_gb    = var.container_ram_gb
  container_num_cores = var.container_num_cores
  container_command   = var.dbt_run_command
  use_fargate         = true
  admin_ports         = local.admin_ports
  environment_vars    = var.environment_vars
  environment_secrets = var.environment_secrets
  schedules = flatten([
    var.scheduled_refresh_interval == null ? [] : ["rate(${var.scheduled_refresh_interval})"],
    [
      # Convert 4-digit time of day into cron. Cron tester: https://crontab.guru/
      for cron_expr in var.scheduled_refresh_times :
      "cron(${
        tonumber(substr(cron_expr, 2, 2))
        } ${
        (24 + tonumber(substr(cron_expr, 0, 2)) - local.tz_hour_offset) % 24
      } * * ? *)"
    ]
  ])
}
