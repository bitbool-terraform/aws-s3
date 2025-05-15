variable "bucket_name" {}

variable "is_public" { default = false }
variable "everything_is_public" { default = false }

variable "bucket_policy" { default = null }

variable "tags" { default = {}}
variable "backup_tags" { default = {}}

variable "enable_versioning" { default = true }

variable "lifecycle_default" { default = true } 

variable "lifecycle_noncurrent_delete_days" { default = 1095 } 
variable "lifecycle_noncurrent_transition_standard_class_days" { default = 30 } 
variable "lifecycle_noncurrent_transition_glacier_class_days" { default = 90 } 

variable "lifecycle_rules_custom" { default = [] }
#variable "object_ownership" { default = "BucketOwnerPreferred" }

variable "force_destroy" { default = false }

variable "trasnfer_acceleration" { default = false }

variable "cors_rules_custom" { default = [] }
variable "cors_allow_domains" { default = [] }