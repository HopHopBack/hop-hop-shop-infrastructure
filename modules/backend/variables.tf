variable "aws_region" {
  description = "region for S3 and DynamoDB"
  default     = "eu-central-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket for holding Terraform state. Must be globally unique."
  type        = string
  default     = "hophops3"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
  default     = "hophopdynamodb"
}
