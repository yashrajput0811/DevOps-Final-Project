#!/bin/bash

# Clean up production environment
cd terraform/environments/prod
terraform destroy -auto-approve

# Clean up test environment
cd ../test
terraform destroy -auto-approve

# Clean up backend
cd ../../modules/backend
terraform destroy -auto-approve

echo "All resources have been cleaned up successfully!" 