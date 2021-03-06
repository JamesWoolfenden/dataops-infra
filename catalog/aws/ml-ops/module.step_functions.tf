module "step-functions" {
  #source                  = "git::https://github.com/slalom-ggp/dataops-infra.git//catalog/aws/data-lake?ref=main"
  source      = "../../../components/aws/step-functions"
  name_prefix = var.name_prefix
  writeable_buckets = [
    var.feature_store_override != null ? data.aws_s3_bucket.feature_store_override[0].id : aws_s3_bucket.feature_store[0].id,
    aws_s3_bucket.extracts_store.id,
    aws_s3_bucket.model_store.id,
    aws_s3_bucket.output_store.id,
  ]
  environment              = var.environment
  common_tags              = var.common_tags
  lambda_functions         = module.lambda_functions.function_ids
  state_machine_definition = <<EOF
{
 "StartAt": "Glue Data Transformation",
  "States": {
    "Glue Data Transformation": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "${module.glue_job.glue_job_name}",
        "Arguments": {
          "--extra-py-files": "s3://${aws_s3_bucket.source_repository.id}/glue/python/pandasmodule-0.1-py3-none-any.whl",
          "--S3_SOURCE": "${var.feature_store_override != null ? data.aws_s3_bucket.feature_store_override[0].id : aws_s3_bucket.feature_store[0].id}",
          "--S3_DEST": "${aws_s3_bucket.extracts_store.id}",
          "--TRAIN_KEY": "data/train/train.csv",
          "--SCORE_KEY": "data/score/score.csv",
          "--INFERENCE_TYPE": "${var.endpoint_or_batch_transform == "Create Model Endpoint Config" ? "endpoint" : "batch"}"
        }
      },
      "Next": "Generate Unique Job Name"
    },
    "Generate Unique Job Name": {
      "Resource": "${module.lambda_functions.function_ids["UniqueJobName"]}",
      "Parameters": {
        "JobName": "${var.job_name}"
      },
      "Type": "Task",
      "Next": "Hyperparameter Tuning"
    },
    "Hyperparameter Tuning": {
      "Resource": "arn:aws:states:::sagemaker:createHyperParameterTuningJob.sync",
      "Parameters": {
        "HyperParameterTuningJobName.$": "$.JobName",
        "HyperParameterTuningJobConfig": {
          "Strategy": "Bayesian",
          "HyperParameterTuningJobObjective": {
            "Type": "${var.tuning_objective}",
            "MetricName": "${var.tuning_metric}"
          },
          "ResourceLimits": {
            "MaxNumberOfTrainingJobs": ${tostring(var.max_number_training_jobs)},
            "MaxParallelTrainingJobs": ${tostring(var.max_parallel_training_jobs)}
          },
          "ParameterRanges": ${jsonencode(var.parameter_ranges)}
        },
        "TrainingJobDefinition": {
          "AlgorithmSpecification": {
            "MetricDefinitions": [
              {
                "Name": "${var.tuning_metric}",
                "Regex": "${var.tuning_metric}: ([0-9\\.]+)"
              }
            ],
            "TrainingImage": "${var.built_in_model_image != null ? var.built_in_model_image : module.ecr_image_byo_model.ecr_image_url_and_tag}",
            "TrainingInputMode": "File"
          },
          "OutputDataConfig": {
            "S3OutputPath": "s3://${aws_s3_bucket.model_store.id}/models"
          },
          "StoppingCondition": {
            "MaxRuntimeInSeconds": 86400
          },
          "ResourceConfig": {
            "InstanceCount": ${var.training_job_instance_count},
            "InstanceType": "${var.training_job_instance_type}",
            "VolumeSizeInGB": ${var.training_job_storage_in_gb}
          },
          "RoleArn": "${module.step-functions.iam_role_arn}",
          "InputDataConfig": [
            {
              "DataSource": {
                "S3DataSource": {
                  "S3DataDistributionType": "FullyReplicated",
                  "S3DataType": "S3Prefix",
                  "S3Uri": "s3://${aws_s3_bucket.extracts_store.id}/data/train/train.csv"
                }
              },
              "ChannelName": "train",
              "ContentType": "csv"
            }
          ],
          "StaticHyperParameters": ${jsonencode(var.static_hyperparameters)}
        }
      },
      "Type": "Task",
      "Next": "Extract Best Model Path"
    },
    "Extract Best Model Path": {
      "Resource": "${module.lambda_functions.function_ids["ExtractModelPath"]}",
      "ResultPath": "$.BestModelResult",
      "Type": "Task",
      "Next": "Query Training Results"
    },
    "Query Training Results": {
      "Resource": "${module.lambda_functions.function_ids["QueryTrainingStatus"]}",
      "Type": "Task",
      "Next": "Inference Rule"
    },
    "Inference Rule": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$['trainingMetrics'][0]['Value']",
          "${var.inference_comparison_operator}": ${var.inference_metric_threshold},
          "Next": "Save Best Model"
        }
      ],
      "Default": "Model Accuracy Too Low"
    },
    "Model Accuracy Too Low": {
      "Comment": "Validation accuracy lower than threshold",
      "Type": "Fail"
    },
    "Save Best Model": {
      "Parameters": {
        "PrimaryContainer": {
          "Image": "${var.built_in_model_image != null ? var.built_in_model_image : module.ecr_image_byo_model.ecr_image_url_and_tag}",
          "Environment": {},
          "ModelDataUrl.$": "$.modelDataUrl"
        },
        "ExecutionRoleArn": "${module.step-functions.iam_role_arn}",
        "ModelName.$": "$.modelName"
      },
      "ResultPath": "$.modelSaveResult",
      "Resource": "arn:aws:states:::sagemaker:createModel",
      "Type": "Task",
      "Next": "${var.endpoint_or_batch_transform}"
    },
    ${var.endpoint_or_batch_transform == "Create Model Endpoint Config" ? data.null_data_source.endpoint_or_batch_transform.outputs["endpoint"] : data.null_data_source.endpoint_or_batch_transform.outputs["batch_transform"]}
  }
}
EOF
}
