/*
* This module automates MLOps tasks associated with training Machine Learning models.
*
* The module leverages Step Functions and Lambda functions as needed. The state machine
* executes hyperparameter tuning, training, and deployments as needed. Deployment options
* supported are Sagemaker endpoints and/or batch inference.
*/


data "null_data_source" "endpoint_or_batch_transform" {
  inputs = {
    # State machine input for creating or updating an inference endpoint
    endpoint = <<EOF
"Create Model Endpoint Config": {
    "Resource": "arn:aws:states:::sagemaker:createEndpointConfig",
    "Parameters": {
      "EndpointConfigName.$": "$.modelName",
      "ProductionVariants": [
        {
          "InitialInstanceCount": ${var.endpoint_instance_count},
          "InstanceType": "${var.endpoint_instance_type}",
          "ModelName.$": "$.modelName",
          "VariantName": "AllTraffic"
        }
      ]
    },
    "Type": "Task",
    "Next": "Check Endpoint Exists"
  },
  "Check Endpoint Exists": {
    "Resource": "${module.lambda_functions.function_ids["CheckEndpointExists"]}",
    "Parameters": {
      "EndpointConfigArn.$": "$.EndpointConfigArn",
      "EndpointName": "${var.endpoint_name}"
    },
    "Type": "Task",
    "Next": "Create or Update Endpoint"
  },
  "Create or Update Endpoint": {
    "Type": "Choice",
    "Choices": [
      {
        "Variable": "$['CreateOrUpdate']",
        "StringEquals": "Update",
        "Next": "Update Existing Model Endpoint"
      }
    ],
    "Default": "Create New Model Endpoint"
  },
  "Create New Model Endpoint": {
    "Resource": "arn:aws:states:::sagemaker:createEndpoint",
    "Parameters": {
      "EndpointConfigName.$": "$.endpointConfig",
      "EndpointName.$": "$.endpointName"
    },
    "Type": "Task",
    "End": true
  },
  "Update Existing Model Endpoint": {
    "Resource": "arn:aws:states:::sagemaker:updateEndpoint",
    "Parameters": {
      "EndpointConfigName.$": "$.endpointConfig",
      "EndpointName.$": "$.endpointName"
    },
    "Type": "Task",
    "End": true
  }
EOF
    # State machine input for batch transformation
    batch_transform = <<EOF
"Batch Transform": {
    "Type": "Task",
    "Resource": "arn:aws:states:::sagemaker:createTransformJob.sync",
    "Parameters": {
      "ModelName.$": "$.modelName",
      "TransformInput": {
        "CompressionType": "None",
        "ContentType": "text/csv",
        "DataSource": {
          "S3DataSource": {
            "S3DataType": "S3Prefix",
            "S3Uri": "s3://${aws_s3_bucket.extracts_store.id}/data/score/score.csv"
          }
        }
      },
      "TransformOutput": {
        "S3OutputPath": "s3://${aws_s3_bucket.output_store.id}/batch-transform-output"
      },
      "TransformResources": {
        "InstanceCount": ${var.batch_transform_instance_count},
        "InstanceType": "${var.batch_transform_instance_type}"
      },
      "TransformJobName.$": "$.modelName"
    },
    "Next": "Rename Batch Transform Output"
    },
"Rename Batch Transform Output": {
  "Type": "Task",
  "Resource": "${module.lambda_functions.function_ids["RenameBatchOutput"]}",
  "Parameters": {
    "Payload": {
      "BucketName": "${aws_s3_bucket.output_store.id}",
      "Path": "batch-transform-output"
    }
  },
  "Next": "Run Glue Crawler"
    },
    "Run Glue Crawler": {
      "Type": "Task",
      "Resource": "${module.lambda_functions.function_ids["RunGlueCrawler"]}",
      "Parameters": {
        "Payload": {
          "CrawlerName": "${module.glue_crawler.glue_crawler_name}"
        }
      },
      "End": true
    }
EOF
  }
}


