resource "aws_instance" "ec2_instances" {
  #checkov:skip= CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"
  count         = var.num_instances
  ami           = data.aws_ami.ec2_ami.id
  instance_type = var.instance_type
  key_name      = var.ssh_keypair_name

  # Distribute instances into the public or private subnets using round-robin distribution.
  subnet_id = element(var.use_private_subnets ? var.environment.private_subnets : var.environment.public_subnets, count.index)

  get_password_data           = var.is_windows
  associate_public_ip_address = var.associate_public_ip_address
  ebs_optimized               = true
  monitoring                  = true
  disable_api_termination     = false

  user_data = var.is_windows ? replace(local.userdata_win, "<script>", "<script>\nSET EC2_NODE_INDEX=${count.index}\n") : replace(local.userdata_lin, "#!/bin/bash", "#!/bin/bash\nexport EC2_NODE_INDEX=${count.index}\n")
  tags = merge(
    var.common_tags,
    { name = "${var.name_prefix}EC2${count.index}" }
  )

  vpc_security_group_ids = flatten([[
    aws_security_group.ec2_sg_admin_ports[0].id,
    aws_security_group.ec2_sg_allow_all_outbound[0].id,
    aws_security_group.ec2_sg_app_ports[0].id
    ], length(var.cluster_ports) == 0 && var.num_instances > 1 ? [] : [
    aws_security_group.ecs_cluster_traffic[0].id
  ]])

  root_block_device {
    volume_type = "gp3"
    volume_size = var.instance_storage_gb
    encrypted   = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }
}
