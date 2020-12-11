
module "triggered_lambda" {
  source      = "../../../components/aws/lambda-python"
  name_prefix = var.name_prefix
  common_tags = var.common_tags
  environment = var.environment

  runtime              = "python3.8"
  lambda_source_folder = var.lambda_python_source
  upload_to_s3         = true
  upload_to_s3_path    = local.s3_path_to_lambda_zip

  functions = {
    for name, def in var.s3_triggers :
    name => {
      description = "'${name}' trigger for data lake events"
      handler     = def.lambda_handler
      environment = def.environment_vars
      secrets     = def.environment_secrets
    }
  }
  s3_triggers = [
    for name, trigger in var.s3_triggers :
    {
      function_name = name
      s3_bucket     = local.data_bucket_name
      s3_path       = trigger.triggering_path
    }
  ]
}
