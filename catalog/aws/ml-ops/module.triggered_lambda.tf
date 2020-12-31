module "triggered_lambda" {
  source      = "../../../components/aws/lambda-python"
  name_prefix = var.name_prefix
  common_tags = var.common_tags
  environment = var.environment

  runtime              = "python3.8"
  lambda_source_folder = "${path.module}/lambda-python"
  upload_to_s3         = false
  upload_to_s3_path    = null

  functions = {
    ExecuteStateMachine = {
      description = "Executes model training state machine when new training data lands in S3."
      handler     = "execute_state_machine.lambda_handler"
      environment = { "state_machine_arn" = module.step-functions.state_machine_arn }
      secrets     = {}
    }
  }
  s3_triggers = [
    {
      function_name = "ExecuteStateMachine"
      s3_bucket     = var.feature_store_override != null ? data.aws_s3_bucket.feature_store_override[0].id : aws_s3_bucket.feature_store[0].id
      s3_path       = "data/train/*"
    }
  ]
}
