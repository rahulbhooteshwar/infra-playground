#!/bin/bash

echo "=== Stopping Simple MongoDB Setup ==="
echo

# Load environment variables
source mongodb.env

echo "Stopping MongoDB container: ${MONGO_CONTAINER_NAME}"
docker compose down

if [ $? -eq 0 ]; then
    echo "MongoDB container stopped successfully."
else
    echo "Error: Failed to stop MongoDB container"
    exit 1
fi

echo
echo "=== MongoDB Stopped ==="
echo "To start again, run: ./start-mongodb.sh"
