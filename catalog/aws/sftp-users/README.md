# AWS SFTP-Users

`/catalog/aws/sftp-users`

## Overview

Automates the management of SFTP user accounts on the AWS Transfer Service. AWS Transfer Service
provides an SFTP interface on top of existing S3 storage resources.

- Designed to be used in combination with the `aws/sftp` module.

## Requirements

No requirements.

## Providers

The following providers are used by this module:

- aws

## Required Inputs

The following input variables are required:

### name_prefix

Description: Standard `name_prefix` module input.

Type: `string`

### environment

Description: Standard `environment` module input.

Type:

```hcl
object({
    vpc_id          = string
    aws_region      = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
```

### resource_tags

Description: Standard `common_tags` module input.

Type: `map(string)`

### sftp_server_id

Description: The ID of the AWS Transfer Server for SFTP connections.

Type: `string`

### secrets_folder

Description: A relative or absolute path of the folder in which to store key files.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### data_bucket

Description: The S3 bucket to connect to via SFTP.

Type: `string`

Default: `null`

### group_permissions

Description: Mapping of group names to list of objects containing the applicable permissions.

Example:
group_permissions = {
uploaders = [
{
path = "data/uploads/"
read = true
write = true
}
]
global_readers = [
{
path = "/"
read = true
write = false
}
]
global_writers = [
{
path = "/"
read = true
write = true
}
]
}

Type:

```hcl
map(list(object({
    path  = string
    read  = bool
    write = bool
  })))
```

Default: `{}`

### users

Description: A set (or unique list) of user IDs.

Type: `set(string)`

Default:

```json
["ajsteers"]
```

### user_groups

Description: A mapping of user IDs to group name.

Type: `map(list(string))`

Default:

```json
{
  "ajsteers": ["global_reader", "uploader"]
}
```

## Outputs

The following outputs are exported:

### aws_secret_secret_access_keys

Description: Mapping of user IDs to their secret access keys (encrypted).

### summary

Description: Standard Output. Human-readable summary of what was created
by the module and (when applicable) how to access those
resources.

---

## Source Files

_Source code for this module is available using the links below._

- [iam.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/sftp-users/iam.tf)
- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/sftp-users/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/sftp-users/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/sftp-users/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
