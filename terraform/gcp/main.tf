terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# 1. Create Service Account and assign IAM roles
resource "google_service_account" "github_actions_sa" {
  account_id   = var.service_account
  display_name = "GitHub Actions Service Account"
}

resource "google_project_iam_member" "artifact_registry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_storage_bucket_iam_member" "bucket_admin" {
  bucket = "energy-hosting"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# 2. Create Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_actions_pool" {
  workload_identity_pool_id = var.workload_identity_pool
  display_name              = var.workload_identity_pool
}

# 3. Create the OIDC Workload Identity Provider
resource "google_iam_workload_identity_pool_provider" "github_actions_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_provider
  display_name                       = "GitHub Provider"
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  attribute_condition = "assertion.repository_owner == \"${var.repo_owner}\""
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# 4. Bind the Service Account to the Workload Identity Pool
resource "google_service_account_iam_binding" "workload_identity_user" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id}/attribute.repository_owner/${var.repo_owner}"
  ]
}