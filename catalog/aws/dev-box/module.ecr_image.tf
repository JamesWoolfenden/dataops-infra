
module "ecr_image" {
  # TODO: use for_each to run jobs in parallel when the feature launches
  # for_each            = var.taps
  source               = "../../../components/aws/ecr-image"
  name_prefix          = local.name_prefix
  environment          = var.environment
  common_tags          = var.common_tags
  aws_credentials_file = var.aws_credentials_file

  repository_name   = "devbox"
  tag               = "latest"
  source_image_path = "${path.module}/resources"
  build_args = {
    source_image = var.source_image
  }
}
