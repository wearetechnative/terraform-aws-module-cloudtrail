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