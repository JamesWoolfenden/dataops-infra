output "airflow_summary" { value = module.airflow.summary }
module "airflow" {
  # source      = "git::https://github.com/slalom-ggp/dataops-infra.git//catalog/aws/airflow?ref=main"
  source      = "../../catalog/aws/airflow"
  name_prefix = local.name_prefix
  environment = module.env.environment
  common_tags = local.common_tags

  # CONFIGURE HERE:

  # container_image = "slalomggp/dataops:test-project-latest-dev"
  container_image   = "puckel/docker-airflow"
  container_command = "webserver"
  environment_vars = {
    "PROJECT_GIT_URL" = "git+https://github.com/slalom-ggp/dataops-infra.git"
  }
  environment_secrets = {
  }

  /* OPTIONALLY, COPY-PASTE ADDITIONAL SETTINGS FROM BELOW:

  admin_password    = "asdfAS12"
  aws_region        = local.aws_region

  */
}
