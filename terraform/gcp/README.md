# Workload Identity Federation for GitHub Actions with Google Cloud

This guide demonstrates how to set up **Workload Identity Federation (WIF)** to allow **GitHub Actions** to authenticate securely to **Google Cloud** without using long-lived service account keys. The configuration is managed using **Terraform**.

## Overview

**Workload Identity Federation** allows external identities (like GitHub Actions) to assume identities in Google Cloud, providing a secure and manageable authentication method. This eliminates the need for storing service account keys in your repositories.

## Prerequisites

- A Google Cloud project with billing enabled.
- Admin permissions to configure IAM roles and Workload Identity Pools.
- A GitHub repository with workflows using **GitHub Actions**.
- [Terraform](https://www.terraform.io/downloads.html) installed.

## Directory Structure

```
terraform/
├── main.tf          # Main Terraform configuration for WIF setup
├── variables.tf     # Input variables for flexible configurations
├── outputs.tf       # Outputs to get important resource information
└── README.md        # This documentation file
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd terraform/gcp
```

### 2. Configure Terraform Variables

Edit `variables.tf` or create a `terraform.tfvars` file to specify your project settings:

```hcl
project_id     = "your-gcp-project-id"
pool_id        = "github-pool"
provider_id    = "github-provider"
repository     = "your-github-username/your-repo"
```

### 3. Initialize and Apply Terraform

Initialize Terraform and apply the configuration to create the Workload Identity Federation setup.

```bash
terraform init
terraform apply
```

### 4. GitHub Actions Workflow Configuration

After applying the Terraform configuration, you'll get the necessary **OIDC provider** and **Service Account** details in the output.

In your GitHub repository, create or modify your GitHub Actions workflow (`.github/workflows/deploy.yaml`) like this:

```yaml
name: Deploy to Google Cloud

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
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Authenticate with Google Cloud
        uses: google-github-actions/auth@v1
        with:
          token_format: 'access_token'
          workload_identity_provider: 'projects/\<project-number\>/locations/global/workloadIdentityPools/\<pool-id\>/providers/\<provider-id\>'
          service_account: '\<service-account-email\>'

      - name: Deploy to GCP
        run: |
          gcloud config set project ${{ secrets.GCP_PROJECT_ID }}
          gcloud app deploy
```

### 5. Grant Required IAM Roles

Ensure the Google Cloud service account has the necessary IAM roles for the resources it needs to manage. You can customize the roles in `main.tf` or add them manually.

Example:

```hcl
resource "google_project_iam_member" "github_sa_permissions" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.github_service_account.email}"
}
```

## Outputs

After applying, Terraform will output:

- **Workload Identity Provider Resource Name**
- **Service Account Email**
- **GitHub Repository Mapping**

Use these outputs to configure your GitHub Actions workflows.

## Cleanup

To remove the resources created by this setup, run:

```bash
terraform destroy
```

## References

- [Google Cloud - Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)
- [Enabling keyless authentication from GitHub Actions](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)
- [GitHub Actions - OIDC Authentication for Google Cloud](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-google-cloud-platform)
- [GitHub Actions - OIDC Authentication](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [GitHub Actions github context](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/accessing-contextual-information-about-workflow-runs#github-context)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

---

By following this guide, you'll have a secure, keyless authentication setup between GitHub Actions and Google Cloud, managed entirely via Terraform.
