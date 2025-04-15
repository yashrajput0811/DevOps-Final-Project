#!/bin/bash

# Initialize Terraform
cd terraform/modules/backend
terraform init

# Apply the backend configuration
terraform apply -auto-approve

# Get the storage account name
STORAGE_ACCOUNT_NAME=$(terraform output -raw storage_account_name)
RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name)

echo "Backend storage deployed successfully!"
echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
echo "Resource Group Name: $RESOURCE_GROUP_NAME" 
