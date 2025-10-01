#!/bin/bash

# Load environment variables from mongodb.env file
source mongodb.env

# Create data directory
mkdir -p ${MONGO_DATA_PATH}
echo "Created data directory: ${MONGO_DATA_PATH}"

# Create log directory
mkdir -p ${MONGO_LOG_PATH}
echo "Created log directory: ${MONGO_LOG_PATH}"

# Ensure the directory for the key file exists
mkdir -p $(dirname ${MONGO_KEYFILE_PATH})

# Generate keyfile for MongoDB authentication if it doesn't exist
if [ ! -f ${MONGO_KEYFILE_PATH} ]; then
    openssl rand -base64 756 > ${MONGO_KEYFILE_PATH}
    chmod 400 ${MONGO_KEYFILE_PATH}
    echo "Generated keyfile at: ${MONGO_KEYFILE_PATH}"
else
    echo "Keyfile already exists at: ${MONGO_KEYFILE_PATH}"
    chmod 400 ${MONGO_KEYFILE_PATH}
fi

echo "Preparation complete. MongoDB directories and keyfile are ready."
