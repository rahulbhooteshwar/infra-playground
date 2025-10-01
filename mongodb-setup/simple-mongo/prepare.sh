#!/bin/bash

# Load environment variables from mongodb.env file
source mongodb.env

# Create data directory
mkdir -p ${MONGO_DATA_PATH}
echo "Created data directory: ${MONGO_DATA_PATH}"

# Create log directory
mkdir -p ${MONGO_LOG_PATH}
echo "Created log directory: ${MONGO_LOG_PATH}"

echo "Preparation complete. MongoDB directories are ready."
