#!/bin/bash

# Roll back to the previous Docker image version
PREVIOUS_VERSION=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep my-devops-app | sort -r | sed -n '2p')

if [ -z "$PREVIOUS_VERSION" ]; then
  echo "❌ No previous version found. Cannot rollback."
  exit 1
fi

echo "🔁 Rolling back to version: $PREVIOUS_VERSION"

# Stop and remove current container
docker ps -q --filter "ancestor=my-devops-app:latest" | xargs docker stop || true
docker ps -a -q --filter "ancestor=my-devops-app:latest" | xargs docker rm || true

# Run the previous image version
docker run -d -p 3000:3000 "$PREVIOUS_VERSION"

