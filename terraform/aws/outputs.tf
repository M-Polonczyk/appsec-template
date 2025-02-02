output "iam_role_arn" {
  description = "The ARN of the GitHub Actions IAM Role"
  value       = aws_iam_role.github_actions_role.arn
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Identity Provider"
  value       = aws_iam_openid_connect_provider.github_actions_provider.arn
}
