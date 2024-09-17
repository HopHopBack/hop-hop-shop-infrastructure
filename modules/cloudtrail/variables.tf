variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "cloudtrail_name" {
  description = "Name of the CloudTrail"
  type        = string
  default     = "default-cloudtrail"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
  default     = "default-cloudtrail-bucket-hophop"
}

variable "include_global_service_events" {
  description = "Whether to include global service events in the CloudTrail"
  type        = bool
  default     = true
}

variable "read_write_type" {
  description = "Read-write type of events to log"
  type        = string
  default     = "All"
}

variable "include_management_events" {
  description = "Whether to include management events in the CloudTrail"
  type        = bool
  default     = true
}



