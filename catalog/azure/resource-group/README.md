---
parent: Infrastructure Catalog
title: Azure Resource-Group
nav_exclude: false
---

# Azure Resource-Group

[`source = "git::https://github.com/slalom-ggp/dataops-infra/tree/main/catalog/azure/resource-group?ref=main"`](https://github.com/slalom-ggp/dataops-infra/tree/main/catalog/azure/resource-group)

## Overview

Deploys a Resource Group within a subscription.

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

### azure_location

Description: The location the Storage Account will exist.

Type: `string`

### resource_group_name

Description: The name of the Resource Group to be created.

Type: `string`

## Optional Inputs

No optional input.

## Outputs

The following outputs are exported:

### summary

Description: Summary of resources created by this module.

### resource_group_name

Description: The `resource_group_name` value to be passed to other Azure Infrastructure Catalog modules.

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/azure/resource-group/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/azure/resource-group/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/azure/resource-group/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
