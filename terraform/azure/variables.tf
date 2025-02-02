variable "location" {
description = "Azure region for resource deployment."
type        = string
default     = "East US"
}

variable "resource_group_name" {
description = "Name of the Azure Resource Group."
type        = string
default     = "github-actions-rg"
}

variable "app_display_name" {
description = "Display name for the Azure AD Application."
type        = string
default     = "GitHub Actions App"
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