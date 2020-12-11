# AWS Environment

`/catalog/aws/environment`

## Overview

The environment module sets up common infrastrcuture like VPCs and network subnets. The `environment` output
from this module is designed to be passed easily to downstream modules, streamlining the reuse of these core components.

## Requirements

No requirements.

## Providers

No provider.

## Required Inputs

The following input variables are required:

### name_prefix

Description: Standard `name_prefix` module input.

Type: `string`

### resource_tags

Description: Standard `common_tags` module input.

Type: `map(string)`

### aws_credentials_file

Description: Path to a valid AWS Credentials file. Used when initializing the AWS provider.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### environment

Description: Standard `environment` module input. (Ignored for the `environment` module.)

Type:

```hcl
object({
    vpc_id          = string
    aws_region      = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
```

Default: `null`

### aws_region

Description: Optional, used for multi-region deployments. Overrides the contextual AWS region with the region code provided.

Type: `any`

Default: `null`

### disabled

Description: As a workaround for unsupported 'count' feature in terraform modules, this switch can be used to disable the module entirely.

Type: `bool`

Default: `false`

### aws_profile

Description: The name of the AWS profile to use. Optional unless set at the main AWS provider level, in which case it is required.

Type: `string`

Default: `null`

### vpc_cidr

Description: Optional. The CIDR block to use for the VPC network.

Type: `string`

Default: `"10.0.0.0/16"`

### subnet_cidrs

Description: Optional. The CIDR blocks to use for the subnets.
The list should have the 2 public subnet cidrs first, followed by the 2 private subnet cidrs.
If omitted, the VPC CIDR block will be split evenly into 4 equally-sized subnets.

Type: `list(string)`

Default: `null`

## Outputs

The following outputs are exported:

### summary

Description: Summary of resources created by this module.

### environment

Description: The `environment` object to be passed as a standard input to other Infrastructure Catalog modules.

### aws_credentials_file

Description: Path to AWS credentials file for the project.

### is_windows_host

Description: True if running on a Windows machine, otherwise False.

### user_home

Description: Path to the admin user's home directory.

### public_route_table

Description: The ID of the route table for public subnets.

### private_route_table

Description: The ID of the route table for private subnets.

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/environment/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/environment/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/environment/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
