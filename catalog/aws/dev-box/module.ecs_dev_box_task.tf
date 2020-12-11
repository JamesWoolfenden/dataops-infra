
module "ecs_dev_box_task" {
  # TODO: use for_each to run jobs in parallel when the feature launches
  # for_each            = var.taps
  source              = "../../../components/aws/ecs-task"
  name_prefix         = local.name_prefix
  environment         = var.environment
  common_tags         = var.common_tags
  ecs_cluster_name    = module.ecs_dev_box_cluster.ecs_cluster_name
  container_image     = module.ecr_image.ecr_image_url_and_tag
  container_ram_gb    = var.container_ram_gb
  container_num_cores = var.container_num_cores
  use_private_subnet  = var.use_private_subnet
  use_fargate         = true
  always_on           = true
  environment_vars = merge(var.settings, {
    SSH_PUBLIC_KEY_BASE64 = local.ssh_public_key_base64
  })
  environment_secrets = var.secrets
  app_ports           = ["22"]
  admin_ports         = ["22"]
}
