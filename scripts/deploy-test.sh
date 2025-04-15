#!/bin/bash

# Initialize Terraform
cd terraform/environments/test
terraform init

# Apply the test environment configuration
terraform apply -auto-approve

# Get the ACR credentials
ACR_NAME=$(terraform output -raw acr_name)
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)

# Get ACR credentials
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)

echo "Test environment deployed successfully!"
echo "ACR Login Server: $ACR_LOGIN_SERVER"
echo "ACR Username: $ACR_USERNAME"
echo "ACR Password: $ACR_PASSWORD"
echo ""
echo "Please add these values to your GitHub secrets:"
echo "ACR_LOGIN_SERVER: $ACR_LOGIN_SERVER"
echo "ACR_USERNAME: $ACR_USERNAME"
echo "ACR_PASSWORD: $ACR_PASSWORD" 
