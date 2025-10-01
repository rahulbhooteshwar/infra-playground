#!/bin/bash

echo "=== MongoDB Docker Compose Setup ==="
echo

# Load environment variables
source mongodb.env
echo "Using MongoDB version: ${MONGO_VERSION}"
echo "Replica set name: ${MONGO_REPLICA_SET_NAME}"
echo

# Run preparation script
echo "Step 1: Preparing environment..."
./prepare.sh

if [ $? -ne 0 ]; then
    echo "Error: Preparation failed"
    exit 1
fi

echo
echo "Step 2: Starting MongoDB containers..."
docker compose up -d

if [ $? -ne 0 ]; then
    echo "Error: Failed to start containers"
    exit 1
fi

echo
echo "Step 3: Waiting for MongoDB to be ready..."
sleep 10

echo
echo "Step 4: Configuring replica set..."
./configure.sh

if [ $? -ne 0 ]; then
    echo "Error: Replica set configuration failed"
    exit 1
fi

echo
echo "=== MongoDB Setup Complete ==="
echo "Connection URL:"
echo "mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@localhost:${MONGO1_PORT},localhost:${MONGO2_PORT},localhost:${MONGO3_PORT}/?replicaSet=${MONGO_REPLICA_SET_NAME}"
echo
echo "To stop: docker compose down"
echo "To view logs: docker compose logs -f"