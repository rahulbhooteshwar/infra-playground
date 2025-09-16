# Redis Single Node Setup with Docker Compose

This setup provides a single-node Redis instance using Docker Compose with data persistence, log persistence, and configurable authentication.

## Features

- 📦 Single Redis instance using Redis 7 Alpine
- 💾 Data persistence to `./data` directory
- 📝 Log persistence to `./logs` directory
- 🔒 Configurable authentication (enabled/disabled via environment variables)
- 🌐 Accessible from host and other applications outside Docker
- 🔄 Auto-restart unless stopped manually
- ❤️ Health checks included

## Quick Start

### Setup Environment

First, create your `.env` file:

```bash
# Copy the template and edit as needed
cp env-template.txt .env

# Or create manually:
cat > .env << 'EOF'
REDIS_PORT=6379
REDIS_AUTH_ENABLED=false
# REDIS_PASSWORD=your_secure_password_here
EOF
```

### Option 1: Redis without Authentication (Default)

```bash
# Start Redis without authentication
docker compose up -d

# Connect from host
redis-cli -h localhost -p 6379 ping
# Should return: PONG
```

### Option 2: Redis with Authentication

1. Edit `.env` file to enable authentication:

```bash
# Enable authentication
REDIS_AUTH_ENABLED=true
REDIS_PASSWORD=YourSecurePasswordHere
```

2. Start Redis with authentication:

```bash
docker compose up -d

# Connect from host with password
redis-cli -h localhost -p 6379 -a YourSecurePasswordHere ping
# Should return: PONG
```

## Configuration

### Environment Variables (.env file)

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `REDIS_PORT` | Redis port on host | `6379` | `6379` |
| `REDIS_AUTH_ENABLED` | Enable/disable authentication | `false` | `true` |
| `REDIS_PASSWORD` | Redis password | `(empty)` | `MySecurePassword123!` |

### Data Persistence

- **Data**: Stored in `./data` directory (RDB snapshots + AOF logs)
- **Logs**: Stored in `./logs/redis.log`

## Commands

```bash
# Start Redis
docker compose up -d

# View logs
docker compose logs -f redis

# Stop Redis
docker compose down

# Restart Redis
docker compose restart redis

# Check Redis status
docker compose ps
```

## Connecting to Redis

### Redis Connection URLs

**Without Authentication:**
```
redis://localhost:6379
```

**With Authentication:**
```
redis://:your_password@localhost:6379
```

**URL Format Explanation:**
- `redis://` - Protocol scheme
- `:password` - Password (prefix with colon, omit entirely if no auth)
- `@localhost` - Host (@ symbol only needed when password is present)
- `:6379` - Port number
- `/0` - Database number (optional, defaults to 0)

**Examples with Database Selection:**
```bash
# Without auth, database 0 (default)
redis://localhost:6379

# Without auth, database 1
redis://localhost:6379/1

# With auth, database 0 (default)
redis://:MySecurePassword123!@localhost:6379

# With auth, database 2
redis://:MySecurePassword123!@localhost:6379/2
```

### From Host Machine

**Using Local Redis CLI (if installed):**
```bash
# Without authentication
redis-cli -h localhost -p 6379

# With authentication
redis-cli -h localhost -p 6379 -a your_password
```

**Using Docker (no local Redis CLI required):**

**Method 1: Execute commands in the running Redis container**
```bash
# Without authentication - interactive shell
docker exec -it redis-local redis-cli

# Without authentication - single command
docker exec redis-local redis-cli ping
docker exec redis-local redis-cli set mykey "hello"
docker exec redis-local redis-cli get mykey

# With authentication - interactive shell
docker exec -it redis-local redis-cli -a your_password

# With authentication - single command
docker exec redis-local redis-cli -a your_password ping
docker exec redis-local redis-cli -a your_password set mykey "hello"
docker exec redis-local redis-cli -a your_password get mykey
```

**Method 2: Use a temporary Redis container to connect**
```bash
# Without authentication
docker run --rm -it --network redis-setup_redis-network redis:7-alpine redis-cli -h redis-local -p 6379

# With authentication
docker run --rm -it --network redis-setup_redis-network redis:7-alpine redis-cli -h redis-local -p 6379 -a your_password

# Connect from host network (if Redis is exposed on host port)
docker run --rm -it --network host redis:7-alpine redis-cli -h localhost -p 6379
```

**Common Redis CLI Commands via Docker:**
```bash
# Test connection
docker exec redis-local redis-cli ping

# Set and get values
docker exec redis-local redis-cli set test_key "test_value"
docker exec redis-local redis-cli get test_key

# List all keys
docker exec redis-local redis-cli keys "*"

# Get Redis info
docker exec redis-local redis-cli info

# Monitor Redis commands in real-time
docker exec redis-local redis-cli monitor

# Check memory usage
docker exec redis-local redis-cli info memory

# Flush all data (be careful!)
docker exec redis-local redis-cli flushall
```

### From Application Code

**Using Connection URLs (Recommended):**

**Python (redis-py):**
```python
import redis

# Without authentication
r = redis.from_url('redis://localhost:6379')

# With authentication
r = redis.from_url('redis://:your_password@localhost:6379')

# With custom database
r = redis.from_url('redis://:your_password@localhost:6379/1')
```

**Node.js (ioredis):**
```javascript
const Redis = require('ioredis');

// Without authentication
const redis = new Redis('redis://localhost:6379');

// With authentication
const redis = new Redis('redis://:your_password@localhost:6379');

// With custom database
const redis = new Redis('redis://:your_password@localhost:6379/1');
```

**Java (Jedis):**
```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

// Without authentication
JedisPool pool = new JedisPool("redis://localhost:6379");

// With authentication
JedisPool pool = new JedisPool("redis://:your_password@localhost:6379");
```

**Alternative: Using Individual Parameters**

**Python (redis-py):**
```python
import redis

# Without authentication
r = redis.Redis(host='localhost', port=6379, db=0)

# With authentication
r = redis.Redis(host='localhost', port=6379, password='your_password', db=0)
```

**Node.js (ioredis):**
```javascript
const Redis = require('ioredis');

// Without authentication
const redis = new Redis(6379, 'localhost');

// With authentication
const redis = new Redis(6379, 'localhost', { password: 'your_password' });
```

## Health Check

The container includes a health check that verifies Redis is responding:

```bash
# Check container health
docker compose ps

# Manual health check
docker exec redis-local redis-cli ping
```

## Security Notes

1. **Authentication**: Set a strong password when enabling authentication
2. **Network**: Redis is configured to accept connections from any IP (0.0.0.0)
3. **Firewall**: Consider firewall rules if exposing to networks beyond localhost
4. **Password Storage**: Keep your `.env` file secure and never commit passwords to version control

## Troubleshooting

### Check Redis Status
```bash
docker compose ps
docker compose logs redis
```

### Test Connection
```bash
# Test basic connectivity (using Docker)
docker exec redis-local redis-cli ping

# Test with authentication (if enabled)
docker exec redis-local redis-cli -a your_password ping

# Alternative: using local redis-cli (if installed)
redis-cli -h localhost -p 6379 ping
redis-cli -h localhost -p 6379 -a your_password ping
```

### Verify Data Persistence
```bash
# Set a key (using Docker)
docker exec redis-local redis-cli set test_key "test_value"

# Alternative: using local redis-cli (if installed)
# redis-cli -h localhost -p 6379 set test_key "test_value"

# Restart Redis
docker compose restart redis

# Check if key persists (using Docker)
docker exec redis-local redis-cli get test_key

# Alternative: using local redis-cli (if installed)
# redis-cli -h localhost -p 6379 get test_key
```

## Directory Structure

```
redis-setup/
├── docker compose.yml    # Main Docker Compose configuration
├── env-template.txt     # Environment variables template
├── .env                 # Environment variables (create from template)
├── redis.conf           # Redis configuration file
├── README.md            # This file
├── data/                # Persistent data directory (auto-created)
└── logs/                # Log files directory (auto-created)
```