#!/bin/bash

# Load environment variables from mongodb.env file
source mongodb.env

# Create data directories
mkdir -p ${MONGO1_DATA_PATH}
mkdir -p ${MONGO2_DATA_PATH}
mkdir -p ${MONGO3_DATA_PATH}

# Create log directories
mkdir -p ${MONGO1_LOG_PATH}
mkdir -p ${MONGO2_LOG_PATH}
mkdir -p ${MONGO3_LOG_PATH}

# Ensure the directory for the key file exists
mkdir -p $(dirname ${MONGO_KEYFILE_PATH})

# Generate SSH key file for MongoDB replica set authentication
openssl rand -base64 756 > ${MONGO_KEYFILE_PATH}
chmod 400 ${MONGO_KEYFILE_PATH}

# Ensure /etc/hosts entries for MongoDB containers
HOSTS_ENTRY="127.0.0.1 ${MONGO1_CONTAINER_NAME} ${MONGO2_CONTAINER_NAME} ${MONGO3_CONTAINER_NAME}"
if ! grep -q "$HOSTS_ENTRY" /etc/hosts; then
  echo "$HOSTS_ENTRY" | sudo tee -a /etc/hosts
  echo "Added MongoDB container entries to /etc/hosts."
else
  echo "MongoDB container entries already exist in /etc/hosts."
fi

echo "Directories created. SSH key file generated at ${MONGO_KEYFILE_PATH}."
