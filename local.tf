locals {
  trail_arn = join(":", ["arn", data.aws_partition.current.id
        , "cloudtrail", data.aws_region.current.name
      , data.aws_caller_identity.current.account_id, "trail/${var.name}"])
}
