
locals {
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
  name_prefix = "${var.name_prefix}Tap-"
  sync_commands = [
    for tap in var.taps :
    "tapdance sync ${tap.id} ${local.target.id} ${join(" ", var.container_args)}"
  ]
  container_command = (
    length(local.sync_commands) == 1 ?
    "${local.sync_commands[0]}" :
    chomp(coalesce(var.container_command,
      <<EOF
/bin/bash -c "${join(" && ", local.sync_commands)}"
EOF
    ))

  )
  target = (
    (var.data_lake_type == "S3") || (var.target == null) ?
    {
      id = "s3-csv"
      settings = {
        # https://gist.github.com/aaronsteers/19eb4d6cba926327f8b25089cb79259b
        # Parse the S3 path into 'bucket' and 'key' values:
        s3_bucket = split("/", split("//", var.data_lake_storage_path)[1])[0]
        s3_key_prefix = join("/",
          [
            join("/", slice(
              split("/", split("//", var.data_lake_storage_path)[1]),
              1,
              length(split("/", split("//", var.data_lake_storage_path)[1]))
            )),
            replace(var.data_file_naming_scheme, "{file}", "")
          ]
        )
      }
      secrets = {
        # AWS creds secrets will be parsed from local env variables, provided by ECS Task Role
        # aws_access_key_id     = "../.secrets/aws-secrets-manager-secrets.yml:S3_CSV_aws_access_key_id"
        # aws_secret_access_key = "../.secrets/aws-secrets-manager-secrets.yml:S3_CSV_aws_secret_access_key"
      }
    } :
    var.target

  )
  container_image = coalesce(
    var.container_image, "dataopstk/tapdance:${var.taps[0].id}-to-${local.target.id}"
  )
}