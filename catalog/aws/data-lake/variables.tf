
variable "name_prefix" {
  description = "Standard `name_prefix` module input."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Standard `environment` module input."
  type = object({
    vpc_id          = string
    aws_region      = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
}

variable "common_tags" {
  description = "Standard `common_tags` module input."
  type        = map(string)
  default = {
    createdby = "terraform"
  }
}


variable "data_bucket_override" {
  description = "Optionally, you can override the default data bucket with a bucket that already exists."
  type        = string
  default     = null
}
variable "lambda_python_source" {
  description = "Local path to a folder containing the lambda source code (e.g. 'resources/fn_log')"
  type        = string
  default     = null
}

variable "s3_triggers" {
  description = <<EOF
List of S3 triggers objects, for example:
```
[{
  function_name       = "fn_log"
  triggering_path     = "*"
  lambda_handler      = "main.lambda_handler"
  environment_vars    = {}
  environment_secrets = {}
}]
```
EOF
  type = map(
    # function_name as map key
    object({
      triggering_path     = string
      lambda_handler      = string
      environment_vars    = map(string)
      environment_secrets = map(string)
    })
  )
  default = {}
}
