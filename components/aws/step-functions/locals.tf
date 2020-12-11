# Hack required to allow time for IAM execution role to propagate
locals {
  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}
