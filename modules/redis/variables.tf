variable "subnet_ids" {
  description = "List of subnet IDs for the ElastiCache subnet group."
  type        = list(string)
}


variable "redis_engine_version" {
  description = "The Redis engine version to use."
  type        = string
  default     = "redis3.2"
}

variable "redis_cluster_id" {
  description = "The ID for the Redis cluster."
  type        = string
  default     = "hophopredis"
}

variable "security_group_cidr_blocks" {
  description = "CIDR blocks to allow access to the Redis security group."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "region" {
  description = "region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
