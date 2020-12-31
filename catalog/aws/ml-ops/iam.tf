
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.name_prefix}lambda_policy"
  description = "Policy for Lambda functions"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sagemaker:Describe*",
                "sagemaker:List*",
                "sagemaker:BatchGetMetrics",
                "sagemaker:GetSearchSuggestions",
                "sagemaker:Search",
                "s3:*",
                "glue:StartCrawler"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = module.lambda_functions.lambda_iam_role
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "lambda_step_function_policy" {
  name        = "${var.name_prefix}lambda_step_function_access"
  description = "Policy for Lambda access to execute the Step Function"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "states:StartExecution",
            "Resource": "${module.step-functions.state_machine_arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_step_functions_policy_attachment" {
  role       = module.triggered_lambda.lambda_iam_role
  policy_arn = aws_iam_policy.lambda_step_function_policy.arn
}
