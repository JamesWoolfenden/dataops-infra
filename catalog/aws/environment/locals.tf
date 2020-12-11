locals {
  is_windows_host      = substr(pathexpand("~"), 0, 1) == "/" ? false : true
  user_home            = pathexpand("~")
  aws_credentials_file = abspath(var.aws_credentials_file)
  aws_creds_file_check = length(filemd5(local.aws_credentials_file)) # Check if missing AWS Credentials file
  aws_user_switch_cmd = (
    local.aws_credentials_file == null ? "n/a" : (
      local.is_windows_host ?
      "SET AWS_SHARED_CREDENTIALS_FILE=${local.aws_credentials_file}" :
      "export AWS_SHARED_CREDENTIALS_FILE=${local.aws_credentials_file}"

    )
  )
}