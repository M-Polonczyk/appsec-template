terraform {
required_providers {
azurerm = {
source  = "hashicorp/azurerm"
version = "3.0.0"
}
}
}

provider "azurerm" {
features {}
}

# 1. Create Resource Group

resource "azurerm_resource_group" "github_actions_rg" {
name     = var.resource_group_name
location = var.location
}

# 2. Create Azure AD Application

resource "azuread_application" "github_actions_app" {
display_name = var.app_display_name
}

# 3. Create Service Principal

resource "azuread_service_principal" "github_actions_sp" {
application_id = azuread_application.github_actions_app.application_id
}

# 4. Federated Identity Credential

resource "azuread_application_federated_identity_credential" "github_actions_fic" {
application_object_id = azuread_application.github_actions_app.object_id
display_name          = "GitHub Actions OIDC"
description           = "Federated identity for GitHub Actions"
audiences             = ["api://AzureADTokenExchange"]
issuer                = "https://token.actions.githubusercontent.com"
subject               = "repo:${var.repo_owner}/${var.repo_name}:ref:refs/heads/${var.branch}"
}

# 5. Assign Role to Service Principal

resource "azurerm_role_assignment" "github_actions_role_assignment" {
scope                = azurerm_resource_group.github_actions_rg.id
role_definition_name = "Contributor"
principal_id         = azuread_service_principal.github_actions_sp.object_id
}