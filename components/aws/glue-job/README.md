# AWS Glue-Job

`/components/aws/glue-job`

## Overview

Glue is AWS's fully managed extract, transform, and load (ETL) service. A Glue job can be used job to run ETL Python scripts.

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

### s3_script_bucket_name

Description: S3 script bucket for Glue transformation job.

Type: `string`

### s3_source_bucket_name

Description: S3 source bucket for Glue transformation job.

Type: `string`

### s3_destination_bucket_name

Description: S3 destination bucket for Glue transformation job.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### local_script_path

Description: Optional. If provided, the local script will automatically be uploaded to the remote bucket path. In not provided, will use s3_script_path instead.

Type: `string`

Default: `null`

### s3_script_path

Description: Ignored if `local_script_path` is provided. Otherwise, the file at this path will be used for the Glue script.

Type: `string`

Default: `null`

### with_spark

Description: (Default=True). True for standard PySpark Glue job. False for Python Shell.

Type: `bool`

Default: `true`

### num_workers

Description: Min 2. The number or worker nodes to dedicate to each instance of the job.

Type: `number`

Default: `2`

### max_instances

Description: The maximum number of simultaneous executions.

Type: `number`

Default: `10`

## Outputs

The following outputs are exported:

### glue_job_name

Description: The name of the Glue job.

### summary

Description: Summary of Glue resources created.

---

## Source Files

_Source code for this module is available using the links below._

- [iam.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/glue-job/iam.tf)
- [main.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/glue-job/main.tf)
- [outputs.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/glue-job/outputs.tf)
- [py-script-upload.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/glue-job/py-script-upload.tf)
- [variables.tf](https://github.com/slalom-ggp/dataops-infra/tree/main//components/aws/glue-job/variables.tf)

---

_**NOTE:** This documentation was auto-generated using
`terraform-docs` and `s-infra` from `slalom.dataops`.
Please do not attempt to manually update this file._
