#!/bin/bash

set -euo pipefail

APP_NAME="my-app"
NAMESPACE="default"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_PATH="$SCRIPT_DIR"

echo "🚀 Deploying $APP_NAME to Kubernetes..."

if [[ ! -f "$DEPLOYMENT_PATH/deployment.yaml" ]] || [[ ! -f "$DEPLOYMENT_PATH/service.yaml" ]]; then
  echo "❌ Missing deployment or service manifest in $DEPLOYMENT_PATH"
  exit 1
fi

kubectl apply -f "$DEPLOYMENT_PATH/deployment.yaml"
kubectl apply -f "$DEPLOYMENT_PATH/service.yaml"

if [[ -f "$DEPLOYMENT_PATH/ingress.yaml" ]]; then
  echo "🌐 Applying Ingress..."
  kubectl apply -f "$DEPLOYMENT_PATH/ingress.yaml"
else
  echo "⚠️  No ingress.yaml found — skipping ingress."
fi

echo "⏳ Waiting for rollout of $APP_NAME..."
kubectl rollout status deployment/"$APP_NAME" --namespace "$NAMESPACE"

echo "✅ Deployment complete."
