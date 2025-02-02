output "service_account_email" {
  description = "Email of the GitHub Actions Service Account"
  value       = google_service_account.github_actions_sa.email
}

output "workload_identity_pool_id" {
  description = "ID of the Workload Identity Pool"
  value       = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
}

output "workload_identity_provider_id" {
  description = "ID of the Workload Identity Provider"
  value       = google_iam_workload_identity_pool_provider.github_actions_provider.workload_identity_pool_provider_id
}