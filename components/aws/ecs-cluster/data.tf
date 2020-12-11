data "aws_ami" "ecs_linux_ami" {
  owners      = ["amazon"] # AWS
  most_recent = true
  filter {
    name = "name"
    values = [
      "*ecs*optimized*",
      "*amazon-linux-2*"
    ]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_availability_zones" "az_list" {}
