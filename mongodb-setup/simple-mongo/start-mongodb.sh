#!/bin/bash

echo "=== Simple MongoDB Docker Setup ==="
echo

# Load environment variables
source mongodb.env
echo "Using MongoDB version: ${MONGO_VERSION}"
echo "Container name: ${MONGO_CONTAINER_NAME}"
echo "Port: ${MONGO_PORT}"
echo

# Run preparation script
echo "Step 1: Preparing environment..."
./prepare.sh

if [ $? -ne 0 ]; then
    echo "Error: Preparation failed"
    exit 1
fi

echo
echo "Step 2: Starting MongoDB container..."
docker-compose up -d

if [ $? -ne 0 ]; then
    echo "Error: Failed to start container"
    exit 1
fi

echo
echo "Step 3: Waiting for MongoDB to be ready..."
sleep 10

echo
echo "=== MongoDB Setup Complete ==="
echo "MongoDB is running on port ${MONGO_PORT}"
echo
echo "Connection details:"
echo "  Host: localhost"
echo "  Port: ${MONGO_PORT}"
echo "  Username: ${MONGO_INITDB_ROOT_USERNAME}"
echo "  Password: ${MONGO_INITDB_ROOT_PASSWORD}"
echo
echo "Connection URL (ready to use):"
echo "mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@localhost:${MONGO_PORT}/"
echo
echo "Copy and paste this URL directly into your application:"
echo "mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@localhost:${MONGO_PORT}/"
echo
echo "Useful commands:"
echo "  To stop: docker-compose down"
echo "  To view logs: docker-compose logs -f"
echo "  To connect via shell: docker exec -it ${MONGO_CONTAINER_NAME} mongosh -u ${MONGO_INITDB_ROOT_USERNAME} -p ${MONGO_INITDB_ROOT_PASSWORD}"
