docker network create --driver bridge qcal-network


<!-- Attach to the network at the time of creation -->
docker run --name my-local-vault --cap-add=IPC_LOCK -e 'VAULT_LOCAL_CONFIG={"storage": {"file": {"path": "/vault/file"}}, "listener": [{"tcp": { "address": "0.0.0.0:8200", "tls_disable": true}}], "default_lease_ttl": "168h", "max_lease_ttl": "720h", "ui": true}' -p 8200:8200 -d -v ~/dev/vault:/vault/file --network qcal-network_dev hashicorp/vault server


<!-- if needed to do it later -->
docker network connect qcal-network_dev my-local-vault