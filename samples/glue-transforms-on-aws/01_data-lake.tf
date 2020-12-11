module "data_lake" {
  # source      = "git::https://github.com/slalom-ggp/dataops-infra.git//catalog/aws/data-lake?ref=master"
  source      = "../../catalog/aws/data-lake"
  name_prefix = "${local.project_shortname}-Tableau-"
  environment = module.env.environment
  common_tags = local.common_tags
}

resource "aws_s3_bucket_object" "raw_data" {
  bucket = module.data_lake.s3_data_bucket
  key    = "RAW/County_Population.csv"
  source = "data/County_Population.csv"

  etag = filemd5(
    "data/County_Population.csv",
  )
}
