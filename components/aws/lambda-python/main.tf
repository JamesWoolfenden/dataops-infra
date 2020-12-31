/*
* AWS Lambda is a platform which enables serverless execution of arbitrary functions. This module specifically focuses on the
* Python implementatin of Lambda functions. Given a path to a folder of one or more python fyles, this module takes care of
* packaging the python code into a zip and uploading to a new Lambda Function in AWS. The module can also be configured with
* S3-based triggers, to run the function automatically whenever a file is landed in a specific S3 path.
*
*/

resource "random_id" "suffix" {
  byte_length = 2
}



resource "aws_lambda_function" "python_lambda" {
  for_each = local.function_names

  # if var.upload_to_s3 == true: use S3 path; otherwise upload directly from local zip path
  filename  = var.upload_to_s3 ? null : data.archive_file.lambda_zip[0].output_path
  s3_bucket = var.upload_to_s3 == false ? null : aws_s3_bucket_object.s3_lambda_zip[0].bucket
  s3_key    = var.upload_to_s3 == false ? null : aws_s3_bucket_object.s3_lambda_zip[0].id
  # s3_object_version = aws_s3_bucket_object.s3_lambda_zip[0].version_id  # requires bucket versioning enabled

  source_code_hash = data.archive_file.lambda_zip[0].output_base64sha256
  function_name    = each.value
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = var.functions[each.value].handler
  runtime          = var.runtime
  timeout          = var.timeout_seconds
  environment {
    variables = merge(
      var.functions[each.value].environment,
      var.functions[each.value].secrets,
      var.common_tags
    )
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_log_group,
    data.archive_file.lambda_zip
  ]
  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  #checkov:skip=CKV_AWS_97: "Ensure CloudWatch logs are encrypted at rest using KMS CMKs"
  count             = local.is_disabled ? 0 : 1
  name              = "/aws/lambda/${var.name_prefix}lambda-${local.random_suffix}"
  retention_in_days = var.retention_in_days
  kms_key_id=var.kms_key_id
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = var.s3_triggers == null ? 0 : length(var.s3_triggers)
  bucket = var.s3_triggers[count.index].s3_bucket
  lambda_function {
    lambda_function_arn = aws_lambda_function.python_lambda[var.s3_triggers[count.index].function_name].arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = split("*", var.s3_triggers[count.index].s3_path)[0]
    filter_suffix       = split("*", var.s3_triggers[count.index].s3_path)[1]
  }
}
