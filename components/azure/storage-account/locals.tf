locals {
  account_name = join("", [lower(var.name_prefix), lower(var.storage_account_name)])
}
