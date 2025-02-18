module "this" {

  source = "github.com/wearetechnative/terraform-aws-s3.git?ref=ca91a44b390d18e1998b3e5446b42e1079a11d5d"

  name = "cloudtrail_${var.name}"
  kms_key_arn = var.kms_key_arn
  bucket_policy_addition = jsondecode(data.aws_iam_policy_document.cloudtrail_s3_bucket_policy.json)
  disable_encryption_enforcement = true # required otherwise CloudTrail wont work
  lifecycle_configuration = var.lifecycle_rules_configuration
}

data "aws_arn" "s3" {
  arn = module.this.s3_arn
}

data "aws_iam_policy_document" "cloudtrail_s3_bucket_policy" {
  source_policy_documents = concat(
    [ data.aws_iam_policy_document.cloudtrail_base_policy.json ]
    , data.aws_iam_policy_document.cloudtrail_account_policy[*].json
    , data.aws_iam_policy_document.cloudtrail_organization_policy[*].json
  )
}

data "aws_iam_policy_document" "cloudtrail_base_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = [ "<bucket>" ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [local.trail_arn]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_account_policy" {
  count = !var.enable_organization_trail ? 1 : 0

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [ "<bucket>/*" ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [local.trail_arn]
    }

    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_organization_policy" {
  count = var.enable_organization_trail ? 1 : 0

  statement {
    sid = "AWSCloudTrailOrganizationWrite"

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [ "<bucket>/*" ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [local.trail_arn]
    }
  }
}
