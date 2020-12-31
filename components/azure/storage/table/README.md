---
parent: Infrastructure Components
title: Storage Table
nav_exclude: false
---

# Storage Table

[`source = "git::https://github.com/slalom-ggp/dataops-infra/tree/main/components/azure/storage/table?ref=main"`](https://github.com/slalom-ggp/dataops-infra/tree/main/components/azure/storage/table)

## Overview

This is the underlying technical component which supports the Storage catalog module for
building Table Storage.

## Requirements

No requirements.

## Providers

The following providers are used by this module:

- azurerm

## Required Inputs

The following input variables are required:

### name_prefix

Description: Standard `name_prefix` module input.

Type: `string`

### common_tags

Description: Standard `common_tags` module input.

Type: `map(string)`

### storage_account_name

Description: The name of the Storage Account the Table(s) will be created under.

Type: `string`

### table_storage_names

Description: Names of Tables to be created.

Type: `list(string)`

## Optional Inputs

No optional input.

## Outputs

The following outputs are exported:

### table_storage_names

Description: The name of the Table(s) created.

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/azure/storage/table/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/azure/storage/table/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/azure/storage/table/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
