resource "aws_ecr_repository" "ecr_repo" {
  name = "${replace(lower(var.repository_name), "_", "-")}/${lower(var.image_name)}"
  tags = var.common_tags
  # lifecycle { prevent_destroy = true }
  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "IMMUTABLE"
}
