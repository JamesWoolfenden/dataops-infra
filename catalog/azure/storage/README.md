---
parent: Infrastructure Catalog
title: Azure Storage
nav_exclude: false
---

# Azure Storage

[`source = "git::https://github.com/slalom-ggp/dataops-infra/tree/main/catalog/azure/storage?ref=main"`](https://github.com/slalom-ggp/dataops-infra/tree/main/catalog/azure/storage)

## Overview

Deploys Storage Containers, Queue Storage, and Table Storage within a storage
account.

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

### storage_account_name

Description: The name of the Storage Account to be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### container_names

Description: Names of Storage Containers to be created.

Type: `list(string)`

Default: `[]`

### table_storage_names

Description: Names of Tables to be created.

Type: `list(string)`

Default: `[]`

### queue_storage_names

Description: Names of Queues to be created.

Type: `list(string)`

Default: `[]`

### container_access_type

Description: The access level configured for the Storage Container(s). Possible values are blob, container or private.

Type: `string`

Default: `"private"`

## Outputs

The following outputs are exported:

### summary

Description: Summary of resources created by this module.

### storage_container_names

Description: The Storage Container name value(s) of the newly created container(s).

### table_storage_names

Description: The Table Storage name value(s) of the newly created table(s).

### queue_storage_names

Description: The Queue Storage name value(s) of the newly created table(s).

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/azure/storage/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/azure/storage/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/azure/storage/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
