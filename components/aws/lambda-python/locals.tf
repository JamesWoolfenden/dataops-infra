locals {
  is_disabled = length(var.functions) == 0 ? true : false
  has_s3_triggers = var.s3_triggers == null ? false : (length(var.s3_triggers) > 0 ? true : false
  )
  is_windows     = substr(pathexpand("~"), 0, 1) == "/" ? false : true
  random_suffix  = lower(random_id.suffix.dec)
  function_names = toset(keys(var.functions))
  function_secrets = {
    for name in local.function_names :
    name => var.functions[name].secrets
    if length(var.functions[name].secrets) > 0
  }
  source_files_hash = local.is_disabled ? "null" : join(",", [
    for filepath in fileset(var.lambda_source_folder, "*") :
    filebase64sha256("${var.lambda_source_folder}/${filepath}")
  ])
  unique_hash       = local.is_disabled ? "na" : md5(local.source_files_hash)
  temp_build_folder = "${path.root}/.terraform/tmp/${var.name_prefix}lambda-zip-${local.unique_hash}"
  zip_local_path    = "${local.temp_build_folder}/../${var.name_prefix}lambda-${local.unique_hash}.zip"
  triggering_bucket_names = var.s3_triggers == null ? [] : [
    for bucket in distinct([
      for trigger in var.s3_triggers :
      trigger.s3_bucket
    ]) :
    bucket
  ]
}