data "aws_availability_zones" "az_list" {}
data "aws_region" "current" {}
data "http" "icanhazip" { url = "http://ipv4.icanhazip.com" }