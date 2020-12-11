#TODO: Remove this old version after all legacy dependencies have cleared.
provider "aws" {
  alias                   = "regional" # used for region-specific AZ lookup
  version                 = "~> 2.10"
  region                  = local.aws_region
  shared_credentials_file = var.aws_credentials_file
  profile                 = var.aws_profile
}

provider "aws" {
  alias                   = "region_lookup" # used for region-specific AZ lookup
  version                 = "~> 2.10"
  region                  = local.aws_region
  shared_credentials_file = var.aws_credentials_file
  profile                 = var.aws_profile
}