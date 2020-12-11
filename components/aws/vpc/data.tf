data "aws_region" "current" {}

#will get the build machines ip if used on a CI server
data "http" "icanhazip" { url = "http://icanhazip.com" }

data "aws_availability_zones" "az_list" {
  provider = aws.region_lookup
}
