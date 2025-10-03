# n8n Workflow Automation Platform

This repository contains the n8n workflow automation platform running in Docker.

## Quick Start

### Initial Setup

```bash
docker compose up --build -d
```

### Access n8n

```bash
http://localhost:5678/home/workflows
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
docker ps
```

### View logs

```bash
docker compose logs -f n8n
```

### Stop container

```bash
docker compose down
```

## Data Persistence

Your n8n data is stored in `/home/ultron/n8n_data` and persists across container updates.

## Configuration

The n8n instance is configured with:

- Port: 5678
- Timezone: CET
- Runners enabled
- Binary data mode: filesystem
- Community packages tool usage enabled
- Max execution timeout: 3600 seconds
