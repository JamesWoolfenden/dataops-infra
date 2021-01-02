


data "http" "icanhazip" {
  count = var.whitelist_terraform_ip ? 1 : 0
  url   = "http://ipv4.icanhazip.com"
}

data "aws_vpc" "vpc_lookup" {
  id = var.environment.vpc_id
}
