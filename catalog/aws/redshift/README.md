# AWS Redshift

`/catalog/aws/redshift`

## Overview

Redshift is an AWS database platform which applies MPP (Massively-Parallel-Processing) principles to big data workloads in the cloud.

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

### common_tags

Description: Standard `common_tags` module input.

Type: `map(string)`

## Optional Inputs

The following input variables are optional (have default values):

### identifier

Description: Optional. The unique identifier for the redshift cluster.

Type: `string`

Default: `null`

### skip_final_snapshot

Description: If true, will allow terraform to destroy the RDS cluster without performing a final backup.

Type: `bool`

Default: `false`

### admin_username

Description: Optional (default='rsadmin'). The initial admin username.

Type: `string`

Default: `"rsadmin"`

### admin_password

Description: The initial admin password. Must be 8 characters long.

Type: `string`

Default: `null`

### elastic_ip

Description: Optional. An Elastic IP endpoint which will be used to for routing incoming traffic.

Type: `string`

Default: `null`

### node_type

Description: Enter the desired node type. The default and cheapest option is 'dc2.large' @ ~$0.25/hr, ~$180/mo (https://aws.amazon.com/redshift/pricing/)

Type: `string`

Default: `"dc2.large"`

### num_nodes

Description: Optional (default=1). The number of Redshift nodes to use.

Type: `number`

Default: `1`

### jdbc_port

Description: Optional. Overrides the default JDBC port for incoming SQL connections.

Type: `number`

Default: `5439`

### kms_key_id

Description: Optional. The ARN for the KMS encryption key used in cluster encryption.

Type: `string`

Default: `null`

### s3_logging_bucket

Description: Optional. An S3 bucket to use for log collection.

Type: `string`

Default: `null`

### s3_logging_path

Description: Required if `s3_logging_bucket` is set. The path within the S3 bucket to use for log storage.

Type: `string`

Default: `null`

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

Description: The Redshift connection endpoint for the new server.

### summary

Description: Summary of resources created by this module.

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/redshift/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/redshift/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/redshift/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
