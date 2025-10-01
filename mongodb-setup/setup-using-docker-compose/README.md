# MongoDB Docker Compose Setup

This setup provides a 3-node MongoDB replica set using Docker Compose with environment-driven configuration.

## Features

- **Environment-driven MongoDB version**: Easily switch between MongoDB versions
- **3-node replica set**: High availability configuration
- **Authentication enabled**: Secure setup with username/password
- **Keyfile authentication**: Inter-node security
- **Persistent data**: Data persisted in local directories

## Configuration

The setup is configured through `mongodb.env`. Key settings:

- `MONGO_VERSION`: MongoDB Docker image version (e.g., `4.4`, `5.0`, `6.0`, `latest`)
- `MONGO_REPLICA_SET_NAME`: Name of the replica set
- `MONGO_INITDB_ROOT_USERNAME`/`MONGO_INITDB_ROOT_PASSWORD`: Admin credentials
- Port configurations for each node
- **Version-specific paths**: Data and logs are automatically organized by version (`./data/${MONGO_VERSION}/` and `./logs/${MONGO_VERSION}/`)

## MongoDB Version Compatibility

### MongoDB 4.4 (Community)
✅ **Fully Compatible**
- Uses legacy `mongo` shell (automatically detected)
- All replica set features supported
- Keyfile authentication supported

### MongoDB 5.0+
✅ **Fully Compatible**
- Uses `mongosh` for versions 6.0+ (automatically detected)
- Enhanced features available

## Quick Start

1. **Configure your environment** (optional):
   ```bash
   # Edit mongodb.env to change MongoDB version or other settings
   nano mongodb.env
   ```

2. **Start the complete setup**:
   ```bash
   ./start-mongodb.sh
   ```

This will:
- Create necessary directories
- Generate keyfile for authentication
- Start all 3 MongoDB containers
- Configure the replica set
- Display connection information

## Manual Steps

If you prefer manual control:

1. **Prepare environment**:
   ```bash
   ./prepare.sh
   ```

2. **Start containers**:
   ```bash
   docker compose up -d
   ```

3. **Configure replica set**:
   ```bash
   ./configure.sh
   ```

## Connection

After setup, connect using:
```
mongodb://admin:password123@localhost:27017,localhost:27018,localhost:27019/?replicaSet=rs0
```

## Management Commands

- **View logs**: `docker compose logs -f`
- **Stop containers**: `docker compose down`
- **Restart**: `docker compose restart`
- **Shell access**: `docker exec -it mongo1 mongo -u admin -p password123`

## Switching MongoDB Versions

The setup uses **version-specific data and log directories**, making version switching safe and easy:

```
data/
├── 4.4/           # MongoDB 4.4 data
│   ├── 1/
│   ├── 2/
│   └── 3/
├── 5.0/           # MongoDB 5.0 data
│   ├── 1/
│   ├── 2/
│   └── 3/
└── 6.0/           # MongoDB 6.0 data
    ├── 1/
    ├── 2/
    └── 3/

logs/
├── 4.4/           # MongoDB 4.4 logs
├── 5.0/           # MongoDB 5.0 logs
└── 6.0/           # MongoDB 6.0 logs
```

To change MongoDB version:

1. Edit `mongodb.env` and change `MONGO_VERSION`
2. Stop existing containers: `docker compose down`
3. Start with new version: `./start-mongodb.sh`

**Benefits:**
- ✅ **Safe switching**: Each version has isolated data
- ✅ **Easy rollback**: Previous version data preserved
- ✅ **No data conflicts**: Avoid corruption between major versions
- ✅ **Version testing**: Test new versions without risk

## Migrating Existing Data

If you have existing data in the old structure (`./data/1`, `./data/2`, `./data/3`), you can migrate it:

```bash
# Create version-specific directories
mkdir -p data/4.4 logs/4.4

# Move existing data (if any)
mv data/1 data/4.4/ 2>/dev/null || true
mv data/2 data/4.4/ 2>/dev/null || true
mv data/3 data/4.4/ 2>/dev/null || true

# Move existing logs (if any)
mv logs/1 logs/4.4/ 2>/dev/null || true
mv logs/2 logs/4.4/ 2>/dev/null || true
mv logs/3 logs/4.4/ 2>/dev/null || true
```

## Troubleshooting

- **Permission errors**: Ensure keyfile has correct permissions (400)
- **Port conflicts**: Check if ports 27017-27019 are available
- **Connection issues**: Verify `/etc/hosts` entries for container names
- **Version issues**: The setup automatically uses the correct shell (`mongo` vs `mongosh`) based on version
- **Path issues**: Version-specific paths are created automatically during setup