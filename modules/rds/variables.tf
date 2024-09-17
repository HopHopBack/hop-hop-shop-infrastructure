variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "hophopbase"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "hophopadmin"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "hophop12345678"
  sensitive   = true
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "region" {
  description = "region"
  type        = string
  default     = "eu-central-1"
}
