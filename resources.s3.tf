module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name

  force_destroy       = var.force_destroy
  acceleration_status = var.trasnfer_acceleration ? "Enabled" : "Suspended"
#  request_payer       = "BucketOwner"

  tags = merge( {Name = var.bucket_name, TFModule = "aws-s3", AwsService = "s3"}, var.backup_tags , var.tags )


  attach_policy           = var.everything_is_public || (var.bucket_policy != null)
  policy                  = var.everything_is_public ?  data.aws_iam_policy_document.everything_public.json : null

  block_public_acls       = !var.is_public
  block_public_policy     = !var.is_public
  ignore_public_acls      = !var.is_public
  restrict_public_buckets = !var.is_public

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  acl = "private" # "acl" conflicts with "grant" and "owner"

  versioning = {
    status     = var.enable_versioning
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "AES256"
      }
    }
  }

  cors_rule = local.cors_rules 

  lifecycle_rule = local.lifecycle_rules

}

locals {

  cors_rule_allow_domains = [{
      allowed_methods = ["GET"]
      allowed_origins = var.cors_allow_domains
      allowed_headers = ["*"]
      expose_headers  = ["ETag"]
      max_age_seconds = 600
      }]

  cors_rules = length(var.cors_allow_domains) == 0 ? var.cors_rules_custom : concat(var.cors_rules_custom,local.cors_rule_allow_domains)

  lifecycle_rule_default = [{
        id                                     = "default"
        enabled                                = true
        abort_incomplete_multipart_upload_days = 7

        filter = {
          prefix = "/"
        }

        noncurrent_version_transition = [
          {
            days          = var.lifecycle_noncurrent_transition_standard_class_days
            storage_class = "STANDARD_IA"
          },
          {
            days          = var.lifecycle_noncurrent_transition_glacier_class_days
            storage_class = "GLACIER"
          },
        ]

        noncurrent_version_expiration = {
          days = var.lifecycle_noncurrent_delete_days
        }
      }]
    

  lifecycle_rules = var.lifecycle_default ? concat(var.lifecycle_rules_custom,local.lifecycle_rule_default) : var.lifecycle_rules_custom
}