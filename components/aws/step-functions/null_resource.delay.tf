
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command     = "sleep 60"
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
  }
  triggers = {
    "states_exec_role" = aws_iam_role.step_functions_role.arn
  }
}