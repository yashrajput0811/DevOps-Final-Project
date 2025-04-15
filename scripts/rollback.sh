#!/bin/bash

# Exit on error
set -e

echo "Initiating rollback..."

# Get the Kubernetes context
kubectl config use-context cst8918-aks-prod

# Get the previous deployment revision
PREVIOUS_REVISION=$(kubectl rollout history deployment/weather-app -n weather-app | grep -v "deployment" | tail -n 2 | head -n 1 | awk '{print $1}')

if [ -z "$PREVIOUS_REVISION" ]; then
    echo "Error: No previous revision found"
    exit 1
fi

# Rollback to the previous revision
echo "Rolling back to revision $PREVIOUS_REVISION..."
kubectl rollout undo deployment/weather-app -n weather-app --to-revision=$PREVIOUS_REVISION

# Wait for rollback to complete
echo "Waiting for rollback to complete..."
kubectl rollout status deployment/weather-app -n weather-app --timeout=300s

# Verify the rollback
echo "Verifying rollback..."
SERVICE_IP=$(kubectl get service weather-app -n weather-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ -z "$SERVICE_IP" ]; then
    echo "Error: Service IP not found after rollback"
    exit 1
fi

# Check if the application is responding
for i in {1..5}; do
    if curl -s "https://$SERVICE_IP/health" | grep -q "ok"; then
        echo "Rollback successful"
        exit 0
    fi
    echo "Attempt $i: Health check failed after rollback, retrying..."
    sleep 10
done

echo "Rollback failed after 5 attempts"
exit 1 
