locals {
  name_prefix = "${var.name_prefix}DBT-"
  admin_cidr  = var.admin_cidr
  admin_ports = ["8080", "10000"]
  tz_hour_offset = (
    contains(["PST"], var.scheduled_timezone) ? -8 :
    contains(["PDT"], var.scheduled_timezone) ? -7 :
    contains(["MST"], var.scheduled_timezone) ? -7 :
    contains(["CST"], var.scheduled_timezone) ? -6 :
    contains(["EST"], var.scheduled_timezone) ? -5 :
    contains(["UTC", "GMT"], var.scheduled_timezone) ? 0 :
    1 / 0
    # ERROR: currently supported timezone code are: "UTC", "GMT", "EST", "PST" and "PDT"
  )
}
