
variable "region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "repo_owner" {
  description = "The GitHub repository owner."
  type        = string
}

variable "repo_name" {
  description = "The GitHub repository name."
  type        = string
}

variable "branch" {
  description = "The branch in the repository for which access is granted."
  type        = string
  default     = "main"
}

variable "iam_role_name" {
  description = "The name of the IAM Role for GitHub Actions."
  type        = string
  default     = "github-actions-role"
}
