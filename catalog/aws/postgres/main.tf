/*
* Deploys a Postgres server running on RDS.
*
* * NOTE: Requires AWS policy 'AmazonRDSFullAccess' on the terraform account
*/

locals {
  name_prefix = "${var.name_prefix}PostgreSQL-"
}
