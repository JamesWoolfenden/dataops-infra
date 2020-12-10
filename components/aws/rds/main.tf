/*
* Deploys an RDS-backed database. RDS currently supports the following database engines:
* * Aurora
* * MySQL
* * PostgreSQL
* * Oracle
* * SQL Server
*
* Each engine type has it's own required configuration. For already-configured database
* configurations, see the catalog modules: `catalog/aws/mysql` and `catalog/aws/postgres`
* which are built on top of this component module.
*
* * NOTE: Requires AWS policy 'AmazonRDSFullAccess' on the terraform account
*/

data "http" "icanhazip" {
  count = var.whitelist_terraform_ip ? 1 : 0
  url   = "http://ipv4.icanhazip.com"
}

resource "random_id" "random_pass" {
  byte_length = 8
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${lower(var.name_prefix)}rds-subnet-group"
  subnet_ids = var.environment.public_subnets
  tags       = var.resource_tags
}

data "aws_vpc" "vpc_lookup" {
  id = var.environment.vpc_id
}

resource "aws_db_instance" "rds_db" {
  identifier          = lower(var.identifier)
  name                = var.database_name
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  kms_key_id          = var.kms_key_id
  port                = var.jdbc_port
  skip_final_snapshot = var.skip_final_snapshot
  allocated_storage   = var.storage_size_in_gb
  username            = var.admin_username
  password            = var.admin_password


  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = flatten([
    [aws_security_group.rds_security_group.id],
    aws_security_group.tf_admin_ip_whitelist.*.id,
    aws_security_group.jdbc_cidr_whitelist.*.id,
  ])

  # apply_immediately   = true
  storage_encrypted = true
}
