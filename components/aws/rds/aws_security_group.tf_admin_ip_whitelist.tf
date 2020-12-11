resource "aws_security_group" "tf_admin_ip_whitelist" {
  count       = var.whitelist_terraform_ip ? 1 : 0
  name_prefix = "${var.name_prefix}rds-tf-admin-whitelist"
  description = "Allow JDBC traffic from Terraform Admin IP"
  vpc_id      = var.environment.vpc_id
  tags        = var.common_tags

  ingress {
    protocol    = "tcp"
    description = "Allow RDS inbound traffic from Terraform Admin IP"
    from_port   = var.jdbc_port
    to_port     = var.jdbc_port
    cidr_blocks = ["${chomp(data.http.icanhazip[0].body)}/32"]
  }
}
