/*
* This data lake implementation creates three buckets, one each for data, logging, and metadata. The data lake also supports lambda functions which can
* trigger automatically when new content is added.
*
* * Designed to be used in combination with the `aws/data-lake-users` module.
* * To add SFTP protocol support, combine this module with the `aws/sftp` module.
*
*/

resource "random_id" "suffix" { byte_length = 2 }

data "aws_s3_bucket" "data_bucket_override" {
  count  = var.data_bucket_override != null ? 1 : 0
  bucket = var.data_bucket_override
}

resource "aws_s3_bucket" "s3_data_bucket" {
  count  = var.data_bucket_override == null ? 1 : 0
  bucket = local.data_bucket
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

resource "aws_s3_bucket" "s3_metadata_bucket" {
  bucket = local.meta_bucket
  acl    = "private"
  tags   = var.common_tags
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "s3_logging_bucket" {
  bucket = local.logging_bucket
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
