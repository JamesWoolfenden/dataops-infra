
resource "random_id" "random_pass" {
  byte_length = 8
}

resource "aws_redshift_subnet_group" "subnet_group" {
  name       = "${lower(var.name_prefix)}redshift-subnet-group"
  subnet_ids = var.environment.public_subnets
  tags       = var.common_tags
}
