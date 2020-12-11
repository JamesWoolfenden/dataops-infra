
module "airflow_ecs_cluster" {
  source      = "../../../components/aws/ecs-cluster"
  name_prefix = var.name_prefix
  environment = var.environment
  common_tags = var.common_tags
}
