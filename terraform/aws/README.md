# AWS Workload Identity Federation for GitHub Actions

This Terraform configuration sets up **Workload Identity Federation** between **GitHub Actions** and **AWS** using **OIDC (OpenID Connect)**. It allows GitHub Actions workflows to assume AWS IAM roles securely without long-lived credentials.

## Prerequisites

1. **Terraform** v1.0+
2. **AWS CLI** configured with appropriate permissions
3. **GitHub Repository** where the workflows will run

## Files Overview

- **main.tf**: Contains AWS resource definitions for IAM Role, Policies, and OIDC Provider.
- **variables.tf**: Defines configurable variables for the setup.
- **outputs.tf**: Outputs key information such as the IAM Role ARN and OIDC Provider ARN.

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure Variables

Edit the `variables.tf` file or create a `terraform.tfvars` file with the following content:

```hcl
repo_owner  = "<your-github-username-or-organization>"
repo_name   = "<your-repository-name>"
region      = "us-east-1"  # or your preferred AWS region
branch      = "main"       # specify the branch if different
```

### 3. Initialize and Apply Terraform

```bash
terraform init
terraform apply -auto-approve
```

### 4. Configure GitHub Actions Workflow

In your GitHub repository, update your workflow file (e.g., `.github/workflows/deploy.yml`) to use the created IAM Role:

```yaml
name: Deploy to AWS

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

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::<account-id>:role/github-actions-role
          aws-region: us-east-1

      - name: Deploy to S3
        run: aws s3 cp ./build s3://<your-bucket-name> --recursive
```

### 5. Verify the Setup

Once you push changes to the specified branch, the GitHub Actions workflow will authenticate to AWS using the configured OIDC provider and assume the IAM role.

## Outputs

After applying the Terraform configuration, the following outputs will be displayed:

- **IAM Role ARN**: The Amazon Resource Name (ARN) of the created IAM role.
- **OIDC Provider ARN**: The ARN of the OIDC provider linked to GitHub Actions.

You can retrieve these values using:

```bash
terraform output iam_role_arn
terraform output oidc_provider_arn
```

## Cleanup

To remove all created resources, run:

```bash
terraform destroy -auto-approve
```

## References

- [GitHub Actions OIDC Authentication](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [AWS IAM OIDC Identity Providers](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html)
