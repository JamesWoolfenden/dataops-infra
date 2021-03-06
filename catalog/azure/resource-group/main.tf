/*
* Deploys a Resource Group within a subscription.
*
*/

module "rg" {
  source              = "../../../components/azure/resource-group"
  name_prefix         = var.name_prefix
  common_tags         = var.common_tags
  azure_location      = var.azure_location
  resource_group_name = var.resource_group_name
}
