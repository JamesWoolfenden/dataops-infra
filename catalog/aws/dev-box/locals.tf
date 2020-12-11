locals {
  name_prefix = "${var.name_prefix}devbox-"
  # container_command = ()
  ssh_public_key_base64 = filebase64(var.ssh_public_key_filepath)
}
