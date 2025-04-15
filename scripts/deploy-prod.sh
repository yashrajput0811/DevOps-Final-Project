#!/bin/bash

# Exit on error
set -e

echo "Deploying production environment..."

# Initialize Terraform
cd terraform/environments/prod
terraform init

# Apply Terraform configuration
terraform apply -auto-approve

# Get ACR credentials
ACR_NAME=$(terraform output -raw acr_name)
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
ACR_USERNAME=$(terraform output -raw acr_username)
ACR_PASSWORD=$(terraform output -raw acr_password)

echo "Production environment deployed successfully!"
echo "ACR Login Server: $ACR_LOGIN_SERVER"
echo "ACR Username: $ACR_USERNAME"
echo "ACR Password: $ACR_PASSWORD"

echo "Please add these values to your GitHub secrets:"
echo "ACR_LOGIN_SERVER: $ACR_LOGIN_SERVER"
echo "ACR_USERNAME: $ACR_USERNAME"
echo "ACR_PASSWORD: $ACR_PASSWORD"

echo "You can access the application at:"
echo "Test Environment: $(terraform output -raw service_ip)"
echo "Production Environment: $(terraform output -raw service_ip)" 
