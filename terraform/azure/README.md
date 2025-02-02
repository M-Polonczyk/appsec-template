# Azure Workload Identity Federation for GitHub Actions

This Terraform configuration sets up **Workload Identity Federation** between **GitHub Actions** and **Azure** using **OIDC (OpenID Connect)**. It allows GitHub Actions workflows to authenticate and access Azure resources securely without using long-lived credentials.

## Prerequisites

1. **Terraform** v1.0+
2. **Azure CLI** installed and logged in
3. **GitHub Repository** where the workflows will run

## Files Overview

- **main.tf**: Contains Azure resource definitions for Resource Group, Azure AD Application, Service Principal, and Federated Identity Credential.
- **variables.tf**: Defines configurable variables for the setup.
- **outputs.tf**: Outputs key information such as the Application ID and Federated Identity Credential ID.

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure Variables

Edit the `variables.tf` file or create a `terraform.tfvars` file with the following content:

```hcl
repo_owner          = "<your-github-username-or-organization>"
repo_name           = "<your-repository-name>"
location            = "East US"  # or your preferred Azure region
resource_group_name = "github-actions-rg"
```

### 3. Initialize and Apply Terraform

```bash
terraform init
terraform apply -auto-approve
```

### 4. Configure GitHub Actions Workflow

In your GitHub repository, update your workflow file (e.g., `.github/workflows/deploy.yml`) to use the created Federated Identity Credential:

```yaml
name: Deploy to Azure

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    permissions:
      id-token: write  # Required for OIDC
      contents: read

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Azure Login
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Deploy to Azure
        run: az group show --name github-actions-rg
```

### 5. Add Secrets to GitHub

Go to your GitHub repository settings and add the following secrets:

- **AZURE_CLIENT_ID**: The `application_id` output from Terraform.
- **AZURE_TENANT_ID**: Your Azure AD tenant ID (retrieve using `az account show --query tenantId -o tsv`).
- **AZURE_SUBSCRIPTION_ID**: Your Azure subscription ID (retrieve using `az account show --query id -o tsv`).

### 6. Verify the Setup

Once you push changes to the specified branch, the GitHub Actions workflow will authenticate to Azure using the configured OIDC provider and perform actions in the specified resource group.

## Outputs

After applying the Terraform configuration, the following outputs will be displayed:

- **Application ID**: The ID of the created Azure AD Application.
- **Service Principal ID**: The ID of the created Service Principal.
- **Federated Identity Credential ID**: The ID of the Federated Identity Credential used by GitHub Actions.

You can retrieve these values using:

```bash
terraform output application_id
terraform output service_principal_id
terraform output federated_identity_credential_id
```

## Cleanup

To remove all created resources, run:

```bash
terraform destroy -auto-approve
```

## References

- [GitHub Actions OIDC Authentication](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [Azure Federated Identity Credential](https://learn.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation)
