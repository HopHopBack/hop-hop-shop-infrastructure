output "cloudtrail_s3_bucket_name" {
  value = aws_s3_bucket.cloudtrail_bucket.bucket
}

output "cloudtrail_name" {
  value = aws_cloudtrail.my_cloudtrail.name
}
