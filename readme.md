# n8n Workflow Automation Platform

A production-ready n8n workflow automation platform running in Docker with dynamic resource scaling, automatic backups, and optimized for scheduled workflows.

## Features

- **Dynamic Resource Scaling**: Minimal resource usage when idle (~512MB RAM), scales up to 4GB for active workflows
- **Automatic Backups**: Daily backups with 7-day retention
- **Auto-Start**: Containers restart automatically on system boot
- **Production Optimized**: Configured for efficient workflow execution
- **Resource Monitoring**: Built-in monitoring script for real-time resource tracking

## Quick Start

### Initial Setup

```bash
# Create backups directory
mkdir -p backups

# Set correct permissions for n8n data
sudo chown -R 1000:1000 /home/ultron/n8n_data

# Start n8n and backup service
docker compose up -d
```

### Access n8n

Open in your browser:
```
http://localhost:5678
```

## Resource Management

### Dynamic Scaling

The configuration automatically adjusts resource usage:

| State | CPU Usage | RAM Usage |
|-------|-----------|-----------|
| **Idle** | ~1-5% | 300-600MB |
| **Light Workflows** | 10-20% | 800MB-1.5GB |
| **Heavy Workflows** | 50-80% | 2.5-4GB |

**Limits:**
- Maximum CPU: 6 cores
- Maximum RAM: 4GB
- Minimum CPU: 0.5 cores
- Minimum RAM: 512MB

### Monitor Resources

Use the built-in monitoring script:

```bash
./monitor-n8n.sh
```

Or use Docker stats:

```bash
docker stats n8n
```

## Backup Management

### Automatic Backups

Backups run daily at midnight and are stored in `./backups/`:
- Retention: 7 days
- Format: `.tar.gz` compressed archives
- Naming: `n8n_backup_YYYYMMDD_HHMMSS.tar.gz`

### Manual Backup

```bash
# Create immediate backup
docker exec n8n-backup tar -czf /backups/n8n_backup_manual_$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
```

### Restore from Backup

```bash
# Stop n8n
docker compose down

# Restore backup
tar -xzf backups/n8n_backup_TIMESTAMP.tar.gz -C /home/ultron/n8n_data/

# Start n8n
docker compose up -d
```

### Customize Backup Schedule

Edit `docker-compose.yml` and modify:
```yaml
- BACKUP_INTERVAL=86400  # Seconds (86400 = daily)
- BACKUP_KEEP_DAYS=7     # Days to keep backups
```

## Updating n8n

To update your n8n container with the latest image:

```bash
# Pull the latest n8n image
docker compose pull

# Recreate container with new image
docker compose up -d --force-recreate
```

## Container Management

### Check container status

```bash
docker compose ps
```

### View logs

```bash
# n8n logs
docker compose logs -f n8n

# Backup service logs
docker compose logs -f n8n-backup

# Both services
docker compose logs -f
```

### Stop containers

```bash
docker compose down
```

### Restart containers

```bash
docker compose restart
```

## Data Persistence

- **Workflows & Data**: `/home/ultron/n8n_data`
- **Backups**: `./backups`
- **Workspace**: `.` (mounted at `/workspace` in container)

All data persists across container updates and system reboots.

## Configuration

### Core Settings

- **Port**: 5678
- **Timezone**: CET
- **Protocol**: HTTP (localhost)
- **Auto-restart**: Yes (unless manually stopped)

### Performance Features

- Task runners enabled (AI/Code execution)
- Concurrent workflow execution (up to 10 workflows)
- Binary data stored on filesystem
- Execution data pruning (7 days, max 50,000 entries)
- Production mode with optimized memory management

### Security

- Git node bare repos disabled
- File access to n8n files blocked
- Community packages enabled with tool usage
- Allowed external modules: moment, lodash, axios, crypto-js, cheerio, puppeteer

### Resource Limits

- **Max execution timeout**: 3 hours per workflow
- **Max payload size**: 256MB
- **Max data table size**: 100MB
- **Node.js heap size**: 3GB

## Troubleshooting

### Container won't start

```bash
# Check logs for errors
docker compose logs n8n

# Verify permissions
ls -la /home/ultron/n8n_data

# Fix permissions if needed
sudo chown -R 1000:1000 /home/ultron/n8n_data
```

### High memory usage when idle

```bash
# Check current usage
docker stats n8n

# Restart container to reset memory
docker compose restart n8n
```

### Backups not working

```bash
# Check backup service logs
docker compose logs n8n-backup

# Verify backups directory exists
ls -la ./backups

# Check backup service is running
docker compose ps n8n-backup
```

### Workflows not triggering

```bash
# Check n8n health
docker exec n8n wget -q -O- http://localhost:5678/healthz

# Verify container is running
docker compose ps

# Check logs for errors
docker compose logs -f n8n
```

## Advanced Configuration

### Adjust Resource Limits

Edit `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: "6.0"      # Adjust max CPU cores
      memory: 4G       # Adjust max RAM
    reservations:
      cpus: "0.5"      # Adjust min CPU
      memory: 512M     # Adjust min RAM
```

### Change Backup Frequency

For hourly backups:
```yaml
- BACKUP_INTERVAL=3600  # 1 hour in seconds
```

For weekly backups:
```yaml
- BACKUP_INTERVAL=604800  # 1 week in seconds
```

## Support

For n8n documentation and support:
- Official Docs: https://docs.n8n.io
- Community Forum: https://community.n8n.io
- GitHub: https://github.com/n8n-io/n8n
