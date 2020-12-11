
locals {
  secrets_names = toset(keys(var.secrets_map))
  existing_secrets_ids_map = {
    # filter existing map for secrets already stored in AWS secrets manager
    for secret_name, location in var.secrets_map :
    secret_name => location
    if replace(secret_name, ":secretsmanager:", "") != secret_name
  }
  new_yaml_secrets_map = {
    # raw secrets which have not yet been stored in AWS secrets manager
    for secret_name, location in var.secrets_map :
    # split the filename from the key name using the ':' delimeter and return the
    # secret value the file
    secret_name => yamldecode(
      file(split(":", location)[0])
    )[split(":", location)[1]] # On failure, please check that the file contains the keys specified.
    if replace(replace(replace(lower(
      location
    ), ".json", ""), ".yml", ""), ".yaml", "") != lower(location)
  }
  new_aws_creds_secrets_map = {
    # raw secrets which have not yet been stored in AWS secrets manager
    for secret_name, location in var.secrets_map :
    # split the filename from the key name using the ':' delimeter and return the
    # secret value the file
    secret_name => regex("${split(":", location)[1]}\\s*?=\\s?(.*)\\b", file(split(":", location)[0]))[0]
    if replace(replace(lower(
      location
    ), ":aws_access_key_id", ""), ":aws_secret_access_key", "") != lower(location)
  }
  new_secrets_map = merge(local.new_yaml_secrets_map, local.new_aws_creds_secrets_map)
  merged_secrets_map = merge(
    local.existing_secrets_ids_map, {
      for created_name in keys(local.new_secrets_map) :
      created_name => aws_secretsmanager_secret.secrets[created_name].id
    }
  )
}
