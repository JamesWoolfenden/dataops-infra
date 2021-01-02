
resource "aws_security_group" "redshift_security_group" {
  name_prefix = "${var.name_prefix}redshift-subnet-group"
  description = "Allow JDBC traffic from VPC subnets"
  vpc_id      = var.environment.vpc_id
  tags        = var.common_tags

  egress {
    protocol    = "tcp"
    description = "Allow all outbound traffic"
    from_port   = var.jdbc_port
    to_port     = var.jdbc_port
    # from_port   = "0"
    # to_port     = "65535"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    description = "Allow Redshift inbound traffic from VPC ${var.environment.vpc_id}"
    from_port   = var.jdbc_port
    to_port     = var.jdbc_port
    cidr_blocks = [data.aws_vpc.vpc_lookup.cidr_block]
  }
}



