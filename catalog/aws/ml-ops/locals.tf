
locals {
  random_bucket_suffix = lower(random_id.suffix.dec)
  feature_store_bucket = (
    var.feature_store_override != null ? data.aws_s3_bucket.feature_store_override[0].id : aws_s3_bucket.feature_store[0].id
  )
}
