
locals {
  project_shortname = substr(var.name_prefix, 0, length(var.name_prefix) - 1)
  policyname        = "ecs_instance-${random_id.suffix.dec}"
  asg_name          = "${var.name_prefix}ECSASG"
  cluster_name      = "${var.name_prefix}ECSCluster"
  profile_name      = "${var.name_prefix}ecs_iam_instance_profile-${random_id.suffix.dec}"
  prefix            = "${var.name_prefix}launch-"

  role_name = "${var.name_prefix}ECSInstanceRole-${random_id.suffix.dec}"
}
