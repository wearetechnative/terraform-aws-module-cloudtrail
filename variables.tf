variable "name" {
  description = "Prefix name for DynamoDB. Must be unique within the region."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key to use for encrypting CloudTrail S3 logs."
  type        = string
}

variable "enable_organization_trail" {
  description = "Use organization trail, requires management account. Disables object level events to prevent cost increase."
  type = bool
  default = false
}

variable "lifecycle_rules_configuration" {
description = "Object Lifecycle rules configuration."
  type = map(object({
    status = string
    bucket_prefix = string
    transition = object({
      storage_class = string
      transition_days = number
    })
    expiration_days = object({
      days = number
      expired_object_delete_marker = bool
    })
    noncurrent_version_expiration = object({
        newer_noncurrent_versions = number
        noncurrent_days = number
    })
    noncurrent_version_transition = object({
        newer_noncurrent_versions = number
        noncurrent_days = number
        storage_class = string
    })
    abort_incomplete_multipart_upload = object({
        days_after_initiation = number
    })
  }))
  default = {}
}