resource "aws_iam_instance_profile" "ecs" {
  name = local.profile_name
  role = aws_iam_role.ecs.id
}
