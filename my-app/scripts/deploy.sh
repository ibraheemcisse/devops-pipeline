#!/bin/bash

set -euo pipefail

APP_NAME="my-app"
NAMESPACE="default"
DEPLOYMENT_PATH="k8s/production"

echo "🚀 Deploying $APP_NAME to Kubernetes..."

# Check if required manifests exist before applying
if [[ ! -f "$DEPLOYMENT_PATH/deployment.yaml" ]] || [[ ! -f "$DEPLOYMENT_PATH/service.yaml" ]]; then
  echo "❌ Missing deployment or service manifest in $DEPLOYMENT_PATH"
  exit 1
fi

# Apply core manifests
kubectl apply -f "$DEPLOYMENT_PATH/deployment.yaml"
kubectl apply -f "$DEPLOYMENT_PATH/service.yaml"

# Apply ingress if available
if [[ -f "$DEPLOYMENT_PATH/ingress.yaml" ]]; then
  echo "🌐 Applying Ingress..."
  kubectl apply -f "$DEPLOYMENT_PATH/ingress.yaml"
else
  echo "⚠️  No ingress.yaml found — skipping ingress."
fi

# Wait for deployment rollout
echo "⏳ Waiting for rollout of $APP_NAME..."
kubectl rollout status deployment/"$APP_NAME" --namespace "$NAMESPACE"

echo "✅ Deployment complete."

