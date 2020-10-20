
resource "aws_security_group" "jdbc_cidr_whitelist" {
  count       = length(var.jdbc_cidr) > 0 ? 1 : 0
  name_prefix = "${var.name_prefix}redshift-jdbc-cidr-whitelist"
  description = "Allow query traffic from specified JDBC CIDR"
  vpc_id      = var.environment.vpc_id
  tags        = var.resource_tags

  ingress {
    protocol    = "tcp"
    description = "Allow Redshift inbound traffic from JDBC CIDR"
    from_port   = var.jdbc_port
    to_port     = var.jdbc_port
    cidr_blocks = var.jdbc_cidr
  }
}
