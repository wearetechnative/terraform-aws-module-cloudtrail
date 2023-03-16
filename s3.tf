module "this" {
  source = "git@github.com:TechNative-B-V/terraform-aws-module-s3.git/?ref=d23eda80e3de956f30f176fc1f2e0cdfa3ac3ae8"

  name = "cloudtrail_${var.name}"
  kms_key_arn = var.kms_key_arn
  bucket_policy_addition = jsondecode(data.aws_iam_policy_document.cloudtrail_s3_bucket_policy.json)
  disable_encryption_enforcement = true # required otherwise CloudTrail wont work
}

data "aws_arn" "s3" {
  arn = module.this.s3_arn
}

data "aws_iam_policy_document" "cloudtrail_s3_bucket_policy" {
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
