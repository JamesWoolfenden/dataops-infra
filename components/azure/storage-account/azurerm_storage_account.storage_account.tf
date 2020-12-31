resource "azurerm_storage_account" "storage_account" {
  #checkov:skip=CKV_AZURE_43: "Ensure the Storage Account naming rules"
  #checkov:skip=CKV_AZURE_35: "Ensure default network access rule for Storage Accounts is set to deny"
  name                      = local.account_name
  tags                      = var.common_tags
  location                  = var.azure_location
  resource_group_name       = var.resource_group_name
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  account_kind              = var.account_kind
  access_tier               = var.access_tier
  enable_https_traffic_only = var.enable_https_traffic_only
  allow_blob_public_access  = var.allow_blob_public_access
  is_hns_enabled            = var.is_hns_enabled
  min_tls_version           = "TLS1_2"
}
