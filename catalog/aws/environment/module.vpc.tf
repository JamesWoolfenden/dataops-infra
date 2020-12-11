
module "vpc" {
  source               = "../../../components/aws/vpc"
  name_prefix          = var.name_prefix
  aws_region           = var.aws_region
  common_tags          = var.common_tags
  aws_credentials_file = local.aws_credentials_file
  aws_profile          = var.aws_profile
  vpc_cidr             = var.vpc_cidr
  subnet_cidrs         = var.subnet_cidrs
}
