locals {
  project_shortname = substr(var.name_prefix, 0, length(var.name_prefix) - 1)
  my_ip             = chomp(data.http.icanhazip.body)
  my_ip_cidr        = "${chomp(data.http.icanhazip.body)}/32"
  aws_region        = coalesce(var.aws_region, data.aws_region.current.name)
  subnet_cidrs = coalesce(
    var.subnet_cidrs,
    cidrsubnets(var.vpc_cidr, 2, 2, 2, 2)
  )
}
