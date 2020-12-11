module "data_lake_on_aws" {
  # source        = "git::https://github.com/slalom-ggp/dataops-infra.git//catalog/aws/data-lake?ref=main"
  source      = "../../catalog/aws/data-lake"
  name_prefix = local.name_prefix
  environment = module.env.environment
  common_tags = local.common_tags

  # ADD OR MODIFY CONFIGURATION HERE:



  /*
  # OPTIONALLY, COPY-PASTE ADDITIONAL SETTINGS FROM BELOW:

  admin_cidr = []
  app_cidr   = ["0.0.0.0/0"]
  */
}

output "data_lake_summary" { value = module.data_lake_on_aws.summary }
