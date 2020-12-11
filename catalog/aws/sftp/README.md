# AWS SFTP

`/catalog/aws/sftp`

## Overview

Automates the management of the AWS Transfer Service, which
provides an SFTP interface on top of existing S3 storage resources.

- Designed to be used in combination with the `aws/data-lake` and `aws/sftp-users` modules.

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

## Optional Inputs

No optional input.

## Outputs

The following outputs are exported:

### sftp_server_arn

Description: The ARN of the Transfer Server.

### sftp_server_id

Description: The ARN of the Transfer Server.

### sftp_endpoint

Description: The endpoint used to connect to the SFTP server. E.g. `s-12345678.server.transfer.REGION.amazonaws.com`

### sftp_host_fingerprint

Description: The message-digest algorithm (MD5) hash of the server's host key.

### summary

Description: Connection information for the SFTP server.

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/sftp/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/sftp/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/sftp/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
