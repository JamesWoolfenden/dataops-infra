module "secrets" {
  source      = "../secrets-manager"
  name_prefix = var.name_prefix
  environment = var.environment
  common_tags = var.common_tags
  secrets_map = var.environment_secrets
  kms_key_id  = var.secrets_manager_kms_key_id
}
