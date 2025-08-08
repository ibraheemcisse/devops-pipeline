#!/bin/bash

echo "🚀 Starting deployment process..."

# Configuration
IMAGE_NAME="devops-dashboard"
CONTAINER_NAME="dashboard-prod"
PORT="8080"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to log messages
log() {
    echo -e "${GREEN}[DEPLOY]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Stop existing container if running
if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
    log "Stopping existing container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Build new image
log "Building new dashboard image..."
cd my-app
if docker build -t $IMAGE_NAME:latest .; then
    log "✅ Image built successfully"
else
    error "❌ Failed to build image"
    exit 1
fi

# Deploy new container
log "Deploying new container..."
if docker run -d -p $PORT:80 --name $CONTAINER_NAME $IMAGE_NAME:latest; then
    log "✅ Container deployed successfully"
else
    error "❌ Failed to deploy container"
    exit 1
fi

# Health check
log "Performing health check..."
sleep 5

if curl -f http://localhost:$PORT > /dev/null 2>&1; then
    log "✅ Health check passed"
    log "🎉 Deployment completed successfully!"
    log "Dashboard available at: http://localhost:$PORT"
else
    error "❌ Health check failed"
    exit 1
fi

# Clean up old images
log "Cleaning up old images..."
docker image prune -f > /dev/null 2>&1

log "Deployment process completed! 🚀"
