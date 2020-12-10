data "aws_ami" "ec2_ami" {
  owners      = [var.ami_owner] # Canonical
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}