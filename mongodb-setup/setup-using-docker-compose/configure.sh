#!/bin/bash

# Load environment variables from mongodb.env file
source mongodb.env

# Check MongoDB version and use appropriate shell command
if [[ "${MONGO_VERSION}" =~ ^[4-5]\. ]]; then
  # For MongoDB 4.x and 5.x, use legacy mongo shell
  MONGO_SHELL_CMD="mongo"
else
  # For MongoDB 6.x and later, use mongosh
  MONGO_SHELL_CMD="mongosh"
fi

# Run the rs.initiate command directly
docker exec -it ${MONGO1_CONTAINER_NAME} ${MONGO_SHELL_CMD} -u ${MONGO_INITDB_ROOT_USERNAME} -p ${MONGO_INITDB_ROOT_PASSWORD} --eval "
rs.initiate({
  _id: '${MONGO_REPLICA_SET_NAME}',
  members: [
    { _id: 0, host: '${MONGO1_CONTAINER_NAME}:${MONGO1_PORT}' },
    { _id: 1, host: '${MONGO2_CONTAINER_NAME}:${MONGO2_PORT}' },
    { _id: 2, host: '${MONGO3_CONTAINER_NAME}:${MONGO3_PORT}' }
  ]
})
"

# Print the connection URL
echo "MongoDB Replica Set connection URL:"
echo "mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@${MONGO1_CONTAINER_NAME}:${MONGO1_PORT},${MONGO2_CONTAINER_NAME}:${MONGO2_PORT},${MONGO3_CONTAINER_NAME}:${MONGO3_PORT}/?replicaSet=${MONGO_REPLICA_SET_NAME}"