locals {
  s3_path_to_lambda_zip = "s3://${aws_s3_bucket.s3_metadata_bucket.id}/code/lambda/${var.name_prefix}lambda.zip"
  random_bucket_suffix  = lower(random_id.suffix.dec)
  data_bucket_name = (var.data_bucket_override != null ? data.aws_s3_bucket.data_bucket_override[0].id : aws_s3_bucket.s3_data_bucket[0].id
  )
  logging_bucket = "${lower(var.name_prefix)}logs-${local.random_bucket_suffix}"
  meta_bucket    = "${lower(var.name_prefix)}meta-${local.random_bucket_suffix}"
  data_bucket    = "${lower(var.name_prefix)}data-${local.random_bucket_suffix}"
}
