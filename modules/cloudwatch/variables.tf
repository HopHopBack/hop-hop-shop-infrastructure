variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization alarm"
  type        = number
}

variable "memory_threshold" {
  description = "Threshold for memory utilization alarm"
  type        = number
}

variable "alarm_topic_arn" {
  description = "ARN of the SNS topic for alarms"
  type        = string
  default     = ""
}
