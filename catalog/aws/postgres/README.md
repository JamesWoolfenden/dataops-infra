# AWS Postgres

`/catalog/aws/postgres`

## Overview

Deploys a Postgres server running on RDS.

- NOTE: Requires AWS policy 'AmazonRDSFullAccess' on the terraform account

## Requirements

No requirements.

## Providers

No provider.

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

### common_tags

Description: Standard `common_tags` module input.

Type: `map(string)`

### admin_username

Description: The initial admin username.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### admin_password

Description: The initial admin password. Must be 8 characters long.

Type: `string`

Default: `null`

### database_name

Description: The name of the initial database to be created.

Type: `string`

Default: `"default_db"`

### elastic_ip

Description: Optional. An Elastic IP endpoint which will be used to for routing incoming traffic.

Type: `string`

Default: `null`

### identifier

Description: The database name which will be used within connection strings and URLs.

Type: `string`

Default: `"rds-postgres-db"`

### instance_class

Description: Enter the desired node type. The default and cheapest option is 'db.t2.micro' @ ~$0.017/hr, or ~$120/mo (https://aws.amazon.com/rds/mysql/pricing/ )

Type: `string`

Default: `"db.t2.micro"`

### jdbc_port

Description: Optional. Overrides the default JDBC port for incoming SQL connections.

Type: `number`

Default: `5432`

### kms_key_id

Description: Optional. The ARN for the KMS encryption key used in cluster encryption.

Type: `string`

Default: `null`

### postgres_version

Description: Optional. Overrides the version of the Postres database engine.

Type: `string`

Default: `"11.5"`

### s3_logging_bucket

Description: Optional. An S3 bucket to use for log collection.

Type: `string`

Default: `null`

### s3_logging_path

Description: Required if `s3_logging_bucket` is set. The path within the S3 bucket to use for log storage.

Type: `string`

Default: `null`

### storage_size_in_gb

Description: The allocated storage value is denoted in GB

Type: `string`

Default: `"10"`

### skip_final_snapshot

Description: If true, will allow terraform to destroy the RDS cluster without performing a final backup.

Type: `bool`

Default: `false`

### jdbc_cidr

Description: List of CIDR blocks which should be allowed to connect to the instance on the JDBC port.

Type: `list(string)`

Default: `[]`

### whitelist_terraform_ip

Description: True to allow the terraform user to connect to the DB instance.

Type: `bool`

Default: `true`

## Outputs

The following outputs are exported:

### endpoint

Description: The Postgres connection endpoint for the new server.

### summary

Description: Summary of resources created by this module.

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/postgres/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/postgres/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/postgres/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
