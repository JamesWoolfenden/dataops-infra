
resource "aws_autoscaling_group" "ecs" {
  count                = var.ec2_instance_count == 0 ? 0 : 1
  name                 = local.asg_name
  availability_zones   = slice(data.aws_availability_zones.az_list.names, 0, 2)
  desired_capacity     = var.ec2_instance_count
  min_size             = var.ec2_instance_count
  max_size             = var.ec2_instance_count
  launch_configuration = aws_launch_configuration.ecs[0].id
}
