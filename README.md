# GitHub Actions Pipelines Template

This repository provides a comprehensive template for setting up GitHub Actions pipelines, including CI/CD, SAST, configuration files, and Terraform scripts for AWS, GCP, and Azure. It follows application security standards and best practices.

## Features

- **CI/CD Pipelines**: Automated workflows for building, testing, and deploying applications.
- **Static Application Security Testing (SAST)**: Integrated security scans to identify vulnerabilities in the codebase.
- **Terraform Configurations**: Infrastructure as Code (IaC) scripts for provisioning resources on AWS, GCP, and Azure.
- **Pre-commit Hooks**: Ensures code quality and consistency before committing changes.
- **Dependabot**: Automated dependency updates to keep the project secure and up-to-date.

## Project Structure

The repository is organized as follows:

```plaintext
.
├── .github/
│   ├── workflows/
│   │   ├── gcp/
│   │   │   └── docker-push.yaml
│   │   ├── go/
│   │   │   └── ci.yaml
│   │   ├── node/
│   │   │   └── ci.yaml
│   │   ├── python/
│   │   │   └── ci.yaml
│   │   ├── ci.yaml
│   │   ├── deploy.yaml
│   │   └── docker-push.yaml
│   └── dependabot.yml
├── terraform/
│   ├── aws/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── README.md
│   ├── azure/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── README.md
│   └── gcp/
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── README.md
├── .pre-commit-config.yaml
├── .gitignore
├── Dockerfile
├── docker-compose.yaml
├── README.md
└── sonar-project.properties
```

### Directories and Files

- **.github/workflows/**: Contains GitHub Actions workflow files for CI/CD pipelines, SAST, and other automated tasks. Each subdirectory contains workflow files for specific languages or frameworks.
  - **gcp/**: GCP action for pushing Ddocker image.
  - **go/**: Go specific CI pipeline.
  - **node/**: Node.js specific CI pipeline.
  - **python/**: Python specific CI pipeline.
- **.github/dependabot.yml**: Configuration file for Dependabot to automate dependency updates.
- **terraform/**: Contains Terraform configurations for provisioning infrastructure on AWS, GCP, and Azure.
  - **aws/**: Terraform scripts for AWS resources.
  - **azure/**: Terraform scripts for Azure resources.
  - **gcp/**: Terraform scripts for Google Cloud resources.
- **.pre-commit-config.yaml**: Configuration for pre-commit hooks to ensure code quality.
- **.gitignore**: Specifies files and directories to be ignored by Git.
- **Dockerfile**: Defines the Docker image for the application.
- **docker-compose.yaml**: Configuration for Docker Compose to manage multi-container Docker applications.
- **README.md**: Provides an overview of the repository, its features, and setup instructions.
- **sonar-project.properties**: Configuration for SonarQube to analyze the project's code quality.

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure Variables

Edit the `variables.tf` files in the respective Terraform directories or create a terraform.tfvars file with the necessary configurations.

### 3. Initialize and Apply Terraform

```bash
terraform init
terraform apply -auto-approve
```

### 4. Configure GitHub Actions Workflows

Update the GitHub Actions workflow files in the workflows directory to suit your project's requirements.

### 5. Add Secrets to GitHub

Go to your GitHub repository settings and add the necessary secrets for authentication and deployment.

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform Documentation](https://learn.hashicorp.com/tutorials/terraform/cloud-workspace)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Snyk](https://snyk.io/)
- [Dependabot](https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically)
- [AWS IAM OIDC Identity Providers](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html)
-[Google Cloud - Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)
- [Azure Federated Identity Credential](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation)

## License

---
This content provides an overview of the repository, its features, and setup instructions.
