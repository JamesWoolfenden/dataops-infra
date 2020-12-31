/*
* Redshift is an AWS database platform which applies MPP (Massively-Parallel-Processing) principles to big data workloads in the cloud.
*
*/

# NOTE: Requires AWS policy 'AmazonRedshiftFullAccess' on the terraform account

data "aws_region" "current" {}

locals {
  name_prefix = "${var.name_prefix}-RS"
}


