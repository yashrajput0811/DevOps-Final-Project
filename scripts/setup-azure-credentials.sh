#!/bin/bash

# Login to Azure
az login

# Create service principal
echo "Creating service principal..."
SP_NAME="cst8918-sp"
SP_OUTPUT=$(az ad sp create-for-rbac --name $SP_NAME --role Contributor --scopes /subscriptions/$(az account show --query id -o tsv))

# Extract values
CLIENT_ID=$(echo $SP_OUTPUT | jq -r '.appId')
CLIENT_SECRET=$(echo $SP_OUTPUT | jq -r '.password')
TENANT_ID=$(echo $SP_OUTPUT | jq -r '.tenant')
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Create Azure credentials JSON
AZURE_CREDENTIALS=$(cat <<EOF
{
  "clientId": "$CLIENT_ID",
  "clientSecret": "$CLIENT_SECRET",
  "subscriptionId": "$SUBSCRIPTION_ID",
  "tenantId": "$TENANT_ID"
}
EOF
)

# Print instructions
echo "Please add the following secrets to your GitHub repository:"
echo ""
echo "AZURE_CLIENT_ID: $CLIENT_ID"
echo "AZURE_CLIENT_SECRET: $CLIENT_SECRET"
echo "AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "AZURE_TENANT_ID: $TENANT_ID"
echo "AZURE_CREDENTIALS: $AZURE_CREDENTIALS"
echo ""
echo "After the ACR is created, you'll need to add these secrets:"
echo "ACR_LOGIN_SERVER: <your-acr-login-server>"
echo "ACR_USERNAME: <your-acr-username>"
echo "ACR_PASSWORD: <your-acr-password>" 