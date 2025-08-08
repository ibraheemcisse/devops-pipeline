#!/bin/bash

echo "🔧 Building DevOps Dashboard..."

# Navigate to app directory
cd my-app

# Build the Docker image
docker build -t devops-dashboard:latest .

echo "✅ Build completed!"
echo "To run: docker run -p 8080:80 devops-dashboard:latest"
