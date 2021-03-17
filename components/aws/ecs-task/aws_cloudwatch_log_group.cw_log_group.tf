resource "aws_cloudwatch_log_group" "cw_log_group" {
  name = "${var.name_prefix}AWSLogs-${random_id.suffix.dec}"
  tags = var.common_tags
  kms_key_id = var.kms_key_id
  retention_in_days = 90
}