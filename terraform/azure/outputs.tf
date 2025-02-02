output "application_id" {
description = "The Application ID of the Azure AD App"
value       = azuread_application.github_actions_app.application_id
}

output "service_principal_id" {
description = "The Service Principal ID"
value       = azuread_service_principal.github_actions_sp.object_id
}

output "federated_identity_credential_id" {
description = "The ID of the Federated Identity Credential"
value       = azuread_application_federated_identity_credential.github_actions_fic.id
}