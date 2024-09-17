variable "region" {
  description = "region"
  default     = "eu-central-1"
}

variable "repository_url" {
  description = "URL of the repository for the Amplify app"
  type        = string
}

variable "github_token" {
  description = "GitHub OAuth token for accessing the repository"
  type        = string
}

variable "branch_name" {
  description = "Branch name to be used in Amplify"
  type        = string
}

variable "id" {
  description = "Public clarity id"
  type        = string
}

variable "api" {
  description = "Public api"
  type        = string
}

variable "framework" {
  type    = string
  default = "next"
}
