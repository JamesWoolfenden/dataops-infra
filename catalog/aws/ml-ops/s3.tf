resource "random_id" "suffix" { byte_length = 2 }

data "aws_s3_bucket" "feature_store_override" {
  count  = var.feature_store_override != null ? 1 : 0
  bucket = var.feature_store_override
}


resource "aws_s3_bucket" "source_repository" {
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  #checkov:skip=CKV_AWS_52: "Ensure S3 bucket has MFA delete enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  bucket = "${lower(var.name_prefix)}source-repository-${local.random_bucket_suffix}"
  acl    = "private"
  tags   = var.common_tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "feature_store" {
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  #checkov:skip=CKV_AWS_52: "Ensure S3 bucket has MFA delete enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  count  = var.feature_store_override == null ? 1 : 0
  bucket = "${lower(var.name_prefix)}feature-store-${local.random_bucket_suffix}"
  acl    = "private"
  tags   = var.common_tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "extracts_store" {
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  #checkov:skip=CKV_AWS_52: "Ensure S3 bucket has MFA delete enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  bucket = "${lower(var.name_prefix)}extracts-store-${local.random_bucket_suffix}"
  acl    = "private"
  tags   = var.common_tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "model_store" {
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  #checkov:skip=CKV_AWS_52: "Ensure S3 bucket has MFA delete enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  bucket = "${lower(var.name_prefix)}model-store-${local.random_bucket_suffix}"
  acl    = "private"
  tags   = var.common_tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "metadata_store" {
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  #checkov:skip=CKV_AWS_52: "Ensure S3 bucket has MFA delete enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  bucket = "${lower(var.name_prefix)}metadata-store-${local.random_bucket_suffix}"
  acl    = "private"
  tags   = var.common_tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "output_store" {
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  #checkov:skip=CKV_AWS_52: "Ensure S3 bucket has MFA delete enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  bucket = "${lower(var.name_prefix)}output-store-${local.random_bucket_suffix}"
  acl    = "private"
  tags   = var.common_tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "train_data" {
  bucket = var.feature_store_override != null ? data.aws_s3_bucket.feature_store_override[0].id : aws_s3_bucket.feature_store[0].id
  key    = "data/train/train.csv"
  source = var.train_local_path

  etag = filemd5(
    var.train_local_path,
  )
}

resource "aws_s3_bucket_object" "score_data" {
  count  = var.score_local_path != null ? 1 : 0
  bucket = var.feature_store_override != null ? data.aws_s3_bucket.feature_store_override[0].id : aws_s3_bucket.feature_store[0].id
  key    = "data/score/score.csv"
  source = var.score_local_path

  etag = filemd5(
    var.score_local_path,
  )
}

resource "aws_s3_bucket_object" "glue_script" {
  bucket = aws_s3_bucket.source_repository.id
  key    = "glue/transform.py"
  source = var.script_path

  etag = filemd5(
    var.script_path,
  )
}

resource "aws_s3_bucket_object" "glue_python_lib" {
  bucket = aws_s3_bucket.source_repository.id
  key    = "glue/python/pandasmodule-0.1-py3-none-any.whl"
  source = var.whl_path

  etag = filemd5(
    var.whl_path,
  )
}
