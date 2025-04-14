#!/bin/bash

# Exit on error
set -e

echo "Verifying deployment health..."

# Get the Kubernetes context
kubectl config use-context cst8918-aks-prod

# Check if all pods are running
echo "Checking pod status..."
kubectl get pods -n weather-app

# Check if all deployments are ready
echo "Checking deployment status..."
kubectl get deployments -n weather-app

# Check if all services are running
echo "Checking service status..."
kubectl get services -n weather-app

# Perform health check
echo "Performing health check..."
SERVICE_IP=$(kubectl get service weather-app -n weather-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ -z "$SERVICE_IP" ]; then
    echo "Error: Service IP not found"
    exit 1
fi

# Check if the application is responding
for i in {1..5}; do
    if curl -s "https://$SERVICE_IP/health" | grep -q "ok"; then
        echo "Health check passed"
        exit 0
    fi
    echo "Attempt $i: Health check failed, retrying..."
    sleep 10
done

echo "Health check failed after 5 attempts"
exit 1 