/*
* EC2 is the virtual machine layer of the AWS platform. This module allows you to pass your own startup scripts, and it streamlines the creation and usage of
* credentials (passwords and/or SSH keypairs) needed to connect to the instances.
*
*
*/


# TODO: Detect EC2 Pricing
# data "http" "ec2_base_pricing_js" {
#   url = "http://a0.awsstatic.com/pricing/1/ec2/linux-od.min.js"
#   request_headers = {
#     "Accept" = "application/javascript"
#   }
# }
# resource "null_resource" "ec2_base_pricing_js" {
#   provisioner "local-exec" {
#     command = "curl http://aws.amazon.com/ec2/pricing/"
#     # curl http://aws.amazon.com/ec2/pricing/ 2>/dev/null | grep 'model:' | sed -e "s/.*'\(.*\)'.*/http:\\1/"
#   }
# }






resource "aws_security_group" "ec2_sg_admin_ports" {
  count       = var.num_instances > 0 ? 1 : 0
  name_prefix = "${var.name_prefix}SecurityGroupForAdminPorts"
  description = "allow admin traffic from whitelisted IPs"
  vpc_id      = var.environment.vpc_id
  tags        = var.common_tags
  dynamic "ingress" {
    for_each = var.admin_ports
    content {
      protocol    = "tcp"
      description = ingress.key
      from_port   = tonumber(split(":", ingress.value)[0])
      to_port     = length(split(":", ingress.value)) > 1 ? tonumber(split(":", ingress.value)[1]) : tonumber(ingress.value)
      cidr_blocks = local.admin_cidr
    }
  }
}

resource "aws_security_group" "ec2_sg_app_ports" {
  count       = var.num_instances > 0 ? 1 : 0
  name_prefix = "${var.name_prefix}SecurityGroupForAppPorts"
  description = "allow app traffic on whitelisted ports"
  vpc_id      = var.environment.vpc_id
  tags        = var.common_tags
  dynamic "ingress" {
    for_each = var.app_ports
    content {
      protocol    = "tcp"
      description = ingress.key
      from_port   = tonumber(split(":", ingress.value)[0])
      to_port     = length(split(":", ingress.value)) > 1 ? tonumber(split(":", ingress.value)[1]) : tonumber(ingress.value)
      cidr_blocks = local.app_cidr
    }
  }
}

resource "aws_security_group" "ec2_sg_allow_all_outbound" {
  count       = var.num_instances > 0 ? 1 : 0
  name_prefix = "${var.name_prefix}SecurityGroupForOutbound"
  description = "allow all outbound traffic"
  vpc_id      = var.environment.vpc_id
  tags        = var.common_tags
  egress {
    protocol    = "tcp"
    from_port   = "0"
    to_port     = "65535"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_cluster_traffic" {
  count       = length(var.cluster_ports) > 0 && var.num_instances > 1 ? 1 : 0
  name_prefix = "${var.name_prefix}SecurityGroupForClustering"
  description = "allow cluster traffic between instances"
  vpc_id      = var.environment.vpc_id
  tags        = var.common_tags
  dynamic "egress" {
    for_each = var.cluster_ports
    content {
      description = egress.key
      self        = true
      protocol    = "tcp"
      from_port   = split(":", egress.value)[0]
      to_port     = reverse(split(":", egress.value))[0]
    }
  }
  dynamic "ingress" {
    for_each = var.cluster_ports
    content {
      description = ingress.key
      self        = true
      protocol    = "tcp"
      from_port   = split(":", ingress.value)[0]
      to_port     = reverse(split(":", ingress.value))[0]
    }
  }
}
