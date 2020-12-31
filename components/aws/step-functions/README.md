# AWS Step-Functions

`/components/aws/step-functions`

## Overview

AWS Step Functions is a service provided by Amazon Web Services that makes it easier to orchestrate multiple AWS services
to accomplish tasks. Step Functions allows you to create steps in a process where the output of one step becomes the input
for another step.

## Requirements

No requirements.

## Providers

The following providers are used by this module:

- random

- null

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

### state_machine_definition

Description: The JSON definition of the state machine to be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### writeable_buckets

Description: Buckets which should be granted write access.

Type: `list(string)`

Default: `[]`

### lambda_functions

Description: Map of function names to ARNs. Used to ensure state machine access to functions.

Type: `map(string)`

Default: `{}`

### ecs_tasks

Description: List of ECS tasks, to ensure state machine access permissions.

Type: `list(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### state_machine_name

Description: The State Machine name.

### state_machine_arn

Description: The State Machine arn.

### iam_role_arn

Description: The IAM role used by the step function to access resources. Can be used to grant
additional permissions to the role.

### state_machine_url

Description:

---

## Source Files

_Source code for this module is available using the links below._

- [iam.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/step-functions/iam.tf)
- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/step-functions/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/step-functions/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/step-functions/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
