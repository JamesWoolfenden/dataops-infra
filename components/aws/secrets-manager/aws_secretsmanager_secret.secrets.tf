/*
* This module takes as input a set of maps from variable names to secrets locations (in YAML or
* JSON). The module uploads those secrets to AWS Secrets Manager and returns the same map pointing
* to the IDs of new AWS Secrets manager locations. Those IDs (aka ARNs) can then safely be handed
* on to other resources which required access to those secrets.
*
* **Usage Notes:**
*
* * Any secrets locations which are already pointing to AWS secrets will simply be passed back through to the output with no changes.
* * For security reasons, this module does not accept inputs for secrets using the clear text of the secrets themselves. To properly use this module, first save the secrets to a YAML or JSON file which is excluded from source control.
*
*/

resource "random_id" "suffix" { byte_length = 2 }

resource "aws_secretsmanager_secret" "secrets" {
  for_each   = toset(keys(local.new_secrets_map))
  name       = "${var.name_prefix}${each.key}-${random_id.suffix.dec}"
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "secrets_value" {
  for_each      = local.new_secrets_map
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value
}
