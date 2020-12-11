
module "ecs_cluster" {
  source      = "../../../components/aws/ecs-cluster"
  name_prefix = local.name_prefix
  environment = var.environment
  common_tags = var.common_tags
}