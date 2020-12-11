resource "aws_ecs_cluster" "ecs" {
  name = local.cluster_name
  tags = var.common_tags
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
