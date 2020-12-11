
module "ecs_tap_sync_task" {
  # TODO: use for_each to run jobs in parallel when the feature launches
  # for_each            = var.taps
  source              = "../../../components/aws/ecs-task"
  name_prefix         = "${local.name_prefix}sync-"
  environment         = var.environment
  common_tags         = var.common_tags
  ecs_cluster_name    = module.ecs_cluster.ecs_cluster_name
  container_image     = local.container_image
  container_command   = local.container_command
  container_ram_gb    = var.container_ram_gb
  container_num_cores = var.container_num_cores
  use_private_subnet  = var.use_private_subnet
  use_fargate         = true
  environment_vars = merge(
    {
      TAP_CONFIG_DIR          = "${var.data_lake_metadata_path}/tap-snapshot-${local.unique_hash}",
      TAP_STATE_FILE          = "${coalesce(var.data_lake_storage_path, var.data_lake_metadata_path)}/${var.state_file_naming_scheme}",
      PIPELINE_VERSION_NUMBER = var.pipeline_version_number
    },
    {
      for k, v in var.taps[0].settings :
      "TAP_${upper(replace(var.taps[0].id, "-", "_"))}_${k}" => v
    },
    {
      for k, v in local.target.settings :
      "TARGET_${upper(replace(local.target.id, "-", "_"))}_${k}" => v
    }
  )
  environment_secrets = merge(
    {
      for k, v in var.taps[0].secrets :
      "TAP_${upper(replace(var.taps[0].id, "-", "_"))}_${k}" => v
    },
    {
      for k, v in local.target.secrets :
      "TARGET_${upper(replace(local.target.id, "-", "_"))}_${k}" => v
    }
  )
  schedules = [
    # Convert 4-digit time of day into cron. Cron tester: https://crontab.guru/
    for cron_expr in var.scheduled_sync_times :
    "cron(${
      tonumber(substr(cron_expr, 2, 2))
      } ${
      (24 + tonumber(substr(cron_expr, 0, 2)) - local.tz_hour_offset) % 24
    } * * ? *)"
  ]
}
