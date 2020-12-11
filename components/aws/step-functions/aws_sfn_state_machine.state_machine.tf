
resource "aws_sfn_state_machine" "state_machine" {
  name = "${lower(var.name_prefix)}state-machine"
  tags = var.common_tags

  definition = var.state_machine_definition
  role_arn   = aws_iam_role.step_functions_role.arn

  depends_on = [null_resource.delay]
}
