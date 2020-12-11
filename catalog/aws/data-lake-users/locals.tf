locals {
  group_names = toset(
    flatten([
      keys(var.group_permissions),
      flatten(values(var.user_groups))
    ])
  )
}
