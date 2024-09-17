variable "repository_name" {
  description = "The name of the ECR public repository"
  type        = string
  default     = "hophoprepocontainers"
}

variable "region" {
  description = "region"
  type        = string
  default     = "eu-central-1"
}
