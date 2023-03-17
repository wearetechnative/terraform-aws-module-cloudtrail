resource "aws_cloudtrail" "this" {
  name = var.name
  s3_bucket_name = data.aws_arn.s3.resource
  enable_logging = true # manually disable

  enable_log_file_validation = true
  include_global_service_events = true
  is_multi_region_trail = var.enable_organization_trail
  is_organization_trail = var.enable_organization_trail
  kms_key_id = var.kms_key_arn

  dynamic "event_selector" {
    for_each = !var.enable_organization_trail ? [1] : []

    content {
      exclude_management_event_sources = []
      include_management_events        = true
      read_write_type                  = "All"

      data_resource {
          type   = "AWS::S3::Object"
          values = ["arn:aws:s3"]
        }
      data_resource {
          type   = "AWS::Lambda::Function"
          values = ["arn:aws:lambda"]
        }
      data_resource {
          type   = "AWS::DynamoDB::Table"
          values = ["arn:aws:dynamodb"]
      }
    }
  }

  lifecycle {
    ignore_changes = [enable_logging]
  }
}
