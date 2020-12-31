# OPTIONAL: Only if using 'bring your own model'

module "ecr_image_byo_model" {
  source               = "../../../components/aws/ecr-image"
  name_prefix          = var.name_prefix
  environment          = var.environment
  common_tags          = var.common_tags
  aws_credentials_file = var.aws_credentials_file

  repository_name   = var.byo_model_image_name
  source_image_path = var.byo_model_image_source_path
  tag               = var.byo_model_image_tag
}
