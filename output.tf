output "cloudtrail_arn" {
  value = aws_cloudtrail.this.arn
}

output "cloudtrail_id" {
  value = aws_cloudtrail.this.id
}

output "cloudtrail_bucket_arn" {
  value = module.this.s3_arn
}

output "cloudtrail_bucket_id" {
  value = module.this.s3_id
}
