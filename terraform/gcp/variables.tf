variable "repo_owner" {
  description = "The GitHub repository owner to bind to the Workload Identity Pool. Format: owner"
  type        = string
}

variable "project_id" {
  description = "The project ID where resources will be created."
  type        = string
}

variable "project_number" {
  description = "The project number where resources will be created."
  type        = string
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
  
}

variable "zone" {
  description = "The zone where resources will be created."
  type        = string
}

variable "service_account" {
  default     = "github-actions"
  description = "GitHub Actions Service Account"
}

variable "workload_identity_pool" {
  default     = "github-actions-pool"
  description = "Name of the workload identity pool."
}

variable "workload_identity_provider" {
  default     = "github"
  description = "Name of the workload identity provider."
}
