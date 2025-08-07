#!/bin/bash

set -e

APP_NAME="my-app"
IMAGE_NAME="$APP_NAME:local"
DEPLOYMENT_PATH="k8s/production"

echo "🚀 Bootstrapping local production-like environment..."

# Step 1: Start minikube if not running
if ! minikube status >/dev/null 2>&1; then
  echo "🔧 Starting minikube..."
  minikube start
else
  echo "✅ Minikube already running."
fi

# Step 2: Point Docker to minikube's daemon
echo "🐳 Switching to Minikube Docker daemon..."
eval "$(minikube docker-env)"

# Step 3: Build Docker image inside minikube
echo "📦 Building Docker image: $IMAGE_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
docker build -t $IMAGE_NAME "$PROJECT_ROOT"

# Step 4: Apply Kubernetes manifests
echo "☸️  Deploying to Kubernetes..."
kubectl apply -f "$DEPLOYMENT_PATH/deployment.yaml"
kubectl apply -f "$DEPLOYMENT_PATH/service.yaml"

# Optional: deploy ingress if exists
  echo "🔌 Enabling Ingress addon..."
  minikube addons enable ingress

  echo "⏳ Waiting for ingress controller to be ready..."
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s

  echo "🌐 Deploying Ingress..."
  kubectl apply -f "$DEPLOYMENT_PATH/ingress.yaml"


# Step 5: Wait for pod to be ready
echo "⏳ Waiting for pod to be ready..."
kubectl rollout status deployment/$APP_NAME

# Step 6: Run health check
echo "❤️ Running health check..."
kubectl port-forward service/$APP_NAME 8080:80 > /dev/null 2>&1 &
PF_PID=$!

sleep 3

bash scripts/health-check.sh

kill $PF_PID

echo "✅ Bootstrap complete. App is running and healthy."
