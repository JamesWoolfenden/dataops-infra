# AWS Airflow

`/catalog/aws/airflow`

## Overview

Airflow is an open source platform to programmatically author, schedule and monitor workflows. More information here: [airflow.apache.org](https://airflow.apache.org/)

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

### container_command

Description: The command to run on the Airflow container.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### container_image

Description: Optional. Overrides the docker image used for Airflow execution.

Type: `string`

Default: `"airflow"`

### container_num_cores

Description: Optional. The number of CPU cores.

Type: `number`

Default: `2`

### container_ram_gb

Description: Optional. The amount of RAM to use, in GB.

Type: `number`

Default: `4`

### environment_vars

Description: A map of environment variables to pass to the Airflow image.

Type: `map(string)`

Default: `{}`

### environment_secrets

Description: A map of environment variable secrets to pass to the airflow image. Each secret value should be either a
Secrets Manager URI or a local JSON or YAML file reference in the form `/path/to/file.yml:name_of_secret`.

Type: `map(string)`

Default: `{}`

### github_repo_ref

Description: The git repo reference to clone onto the airflow server

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### airflow_url

Description: Link to the airflow web UI.

### logging_url

Description: Link to Airflow logs in Cloudwatch.

### server_launch_cli

Description: Command to launch the Airflow web server via ECS.

### summary

Description: Summary of resources created by this module.

---

## Source Files

_Source code for this module is available using the links below._

- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/airflow/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/airflow/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//catalog/aws/airflow/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
