
resource "aws_launch_configuration" "ecs" {
  count                       = var.ec2_instance_count == 0 ? 0 : 1
  name_prefix                 = local.prefix
  associate_public_ip_address = true
  ebs_optimized               = true
  enable_monitoring           = true
  instance_type               = var.ec2_instance_type
  image_id                    = data.aws_ami.ecs_linux_ami.id
  iam_instance_profile        = aws_iam_instance_profile.ecs.id

  user_data = <<USER_DATA
#!/usr/bin/env bash
echo ECS_CLUSTER=${aws_ecs_cluster.ecs.name} >> /etc/ecs/ecs.config
USER_DATA

  root_block_device {
    encrypted = true
  }
}
