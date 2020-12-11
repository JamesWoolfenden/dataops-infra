# AWS ECS-Task

`/components/aws/ecs-task`

## Overview

ECS, or EC2 Container Service, is able to run docker containers natively in AWS cloud. While the module can support classic EC2-based and Fargate,
features, this module generally prefers "ECS Fargete", which allows dynamic launching of docker containers with no always-on cost and no servers
to manage or pay for when tasks are not running.

Use in combination with the `ECS-Cluster` component.

## Requirements

No requirements.

## Providers

The following providers are used by this module:

- random

- aws

- null

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

### container_image

Description: Examples: 'python:3.8', [aws\_account\_id].dkr.ecr.[aws\_region].amazonaws.com/[repo\_name]

Type: `string`

### ecs_cluster_name

Description: The name of the ECS Cluster to use.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### always_on

Description: True to create an ECS Service with a single 'always-on' task instance.

Type: `bool`

Default: `false`

### admin_ports

Description: A list of admin ports (to be governed by `admin_cidr`).

Type: `list(string)`

Default:

```json
["8080"]
```

### app_ports

Description: A list of app ports (will be governed by `app_cidr`).

Type: `list(string)`

Default:

```json
["8080"]
```

### container_command

Description: Optional. Overrides 'command' for the image.

Type: `any`

Default: `null`

### container_entrypoint

Description: Optional. Overrides the 'entrypoint' for the image.

Type: `any`

Default: `null`

### container_name

Description: Optional. Overrides the name of the default container.

Type: `string`

Default: `"DefaultContainer"`

### container_num_cores

Description: The number of CPU cores to dedicate to the container.

Type: `string`

Default: `"4"`

### container_ram_gb

Description: The amount of RAM to dedicate to the container.

Type: `string`

Default: `"8"`

### ecs_launch_type

Description: 'FARGATE' or 'Standard'

Type: `string`

Default: `"FARGATE"`

### environment_secrets

Description: Mapping of environment variable names to secret manager ARNs or local file secrets. Examples:

- arn:aws:secretsmanager:[aws\_region]:[aws\_account]:secret:prod/ECSRunner/AWS_SECRET_ACCESS_KEY
- path/to/file.json:MY_KEY_NAME_1
- path/to/file.yml:MY_KEY_NAME_2

Type: `map(string)`

Default: `{}`

### environment_vars

Description: Mapping of environment variable names to their values.

Type: `map(string)`

Default: `{}`

### load_balancer_arn

Description: Required only if `use_load_balancer` = True. The load balancer to use for inbound traffic.

Type: `string`

Default: `null`

### permitted_s3_buckets

Description: A list of bucket names, to which the ECS task will be granted read/write access.

Type: `list(string)`

Default: `null`

### schedules

Description: A lists of scheduled execution times.

Type: `set(string)`

Default: `[]`

### secrets_manager_kms_key_id

Description: Optional. Overrides the KMS key used when storing secrets in AWS Secrets Manager.

Type: `string`

Default: `null`

### use_load_balancer

Description: True to receive inbound traffic from the load balancer specified in `load_balancer_arn`.

Type: `bool`

Default: `false`

### use_fargate

Description: True to use Fargate for task execution (default), False to use EC2 (classic).

Type: `bool`

Default: `true`

### use_private_subnet

Description: If True, tasks will use a private subnet and will require a NAT gateway to pull the docker
image, and for any outbound traffic. If False, tasks will use a public subnet and will not
require a NAT gateway.

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### cloudwatch_log_group_name

Description: Name of Cloudwatch log group used for this task.

### ecs_checklogs_cli

Description: Command-ling string used to print Cloudwatch logs locally.

### ecs_container_name

Description: The name of the task's primary container.

### ecs_task_execution_role

Description: An IAM role which has access to execute the ECS Task.

### ecs_logging_url

Description: Link to Cloudwatch logs for this task.

### ecs_runtask_cli

Description: Command-line string used to trigger on-demand execution of the Task.

### ecs_task_name

Description: The name of the ECS task.

### ecs_security_group

Description: The name of the EC2 security group used by ECS.

### load_balancer_arn

Description: The unique ID (ARN) of the load balancer (if applicable).

### load_balancer_dns

Description: The DNS of the load balancer (if applicable).

### subnets

Description: A list of subnets used for task execution.

---

## Source Files

_Source code for this module is available using the links below._

- [alb.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/ecs-task/alb.tf)
- [iam.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/ecs-task/iam.tf)
- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/ecs-task/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/ecs-task/outputs.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/ecs-task/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
