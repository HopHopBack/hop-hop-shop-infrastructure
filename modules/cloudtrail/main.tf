resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "cloudtrail-bucket"
  }
}

resource "aws_cloudtrail" "my_cloudtrail" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
  include_global_service_events = var.include_global_service_events
  cloud_watch_logs_group_arn    = module.cloudwatch.cloudtrail_log_group_arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cw_role.arn

  event_selector {
    read_write_type           = var.read_write_type
    include_management_events = var.include_management_events
  }

  tags = {
    Name = var.cloudtrail_name
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:ListBucket"
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
