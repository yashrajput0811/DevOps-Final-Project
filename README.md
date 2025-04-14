# CST8918 - DevOps: Infrastructure as Code Final Project

## Project Overview
This project implements Infrastructure as Code (IaC) using Terraform to deploy the Remix Weather Application on Azure Kubernetes Service (AKS). The infrastructure includes:
- Azure Blob Storage for Terraform backend
- Azure Kubernetes Service (AKS) clusters for test and production environments
- Azure Cache for Redis for weather data caching
- Azure Container Registry (ACR) for Docker image storage

## Team Members
- [Yash Rajput](https://github.com/yashrajput0811)

## Project Structure
```
.
├── terraform/
│   ├── modules/
│   │   ├── backend/     # Azure Blob Storage configuration
│   │   ├── network/     # Network infrastructure
│   │   ├── aks/         # AKS cluster configuration
│   │   └── app/         # Application resources
│   └── environments/
│       ├── dev/         # Development environment
│       ├── test/        # Test environment
│       └── prod/        # Production environment
└── .github/workflows/   # GitHub Actions workflows
```

## Prerequisites
- Azure CLI
- Terraform
- kubectl
- GitHub account with repository access

## Setup Instructions
1. Clone the repository
2. Install required tools (Azure CLI, Terraform, kubectl)
3. Configure Azure credentials
4. Set up GitHub secrets (see below)

## GitHub Secrets Required
The following secrets need to be configured in the GitHub repository:
- `AZURE_CLIENT_ID`: Azure service principal client ID
- `AZURE_TENANT_ID`: Azure tenant ID
- `AZURE_SUBSCRIPTION_ID`: Azure subscription ID
- `AZURE_CLIENT_SECRET`: Azure service principal client secret

## GitHub Actions Workflows
- Static Analysis: Runs on every push
- Terraform Plan: Runs on pull requests to main
- Infrastructure Deployment: Runs on merge to main
- Application Deployment: Runs on merge to main

## Cleanup
To avoid Azure charges, run the cleanup script after completing the project:
```bash
terraform destroy
```

Last pipeline trigger: $(date +"%Y-%m-%d %H:%M:%S") 

# Updated infrastructure documentation
# Updated infrastructure documentation
