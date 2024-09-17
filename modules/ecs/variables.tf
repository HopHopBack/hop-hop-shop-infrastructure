variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "sg_id" {
  description = "Security group ID"
  type        = string
}

variable "nextjs_image" {
  description = "Docker image for Next.js"
  type        = string
  default     = "nextjs:latest"
}

variable "django_image" {
  description = "Docker image for Django"
  type        = string
  default     = "django:latest"
}

variable "region" {
  description = "region AWS"
  type        = string
  default     = "eu-central-1"
}

variable "alb_nextjs_target_group_arn" {
  type        = string
  description = "The ARN of the Next.js ALB Target Group"
}

variable "alb_django_target_group_arn" {
  type        = string
  description = "The ARN of the Django ALB Target Group"
}
