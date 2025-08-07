#!/bin/bash
set -e

echo "🔍 Performing health check on localhost:8080..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

if [ "$HTTP_CODE" == "200" ]; then
  echo "✅ Health check passed!"
else
  echo "❌ Health check failed with status: $HTTP_CODE"
  exit 1
fi
