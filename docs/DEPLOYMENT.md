# Deployment Guide

This guide covers deploying the Odoo MCP Server to production.

## Prerequisites

### Required
- Python 3.11 or higher
- Odoo 18 instance with `/odooclaw/call_kw_as_user` endpoint
- Odoo user credentials with appropriate permissions
- Network access to Odoo instance

### Optional
- Docker/Podman for containerization
- Reverse proxy (nginx, caddy) for TLS
- Process manager (systemd, supervisord)
- Log aggregation (ELK, Loki)

## Installation

### Method 1: pip install (Recommended for Production)

```bash
# Create virtual environment
python3.11 -m venv odoo-mcp-env
source odoo-mcp-env/bin/activate

# Install from PyPI (when published)
pip install odoo-mcp

# Or install from local repository
pip install -e /path/to/odoo-mcp
```

### Method 2: From Source

```bash
# Clone repository
git clone https://github.com/nicolasramos/odoo-mcp.git
cd odoo-mcp

# Create virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Method 3: Docker (Recommended for Containerization)

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user
RUN useradd -m -u 1000 odoo-mcp
USER odoo-mcp

# Expose MCP port (if using stdio, this isn't needed)
# EXPOSE 8000

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "-m", "odoo_mcp"]
```

Build and run:

```bash
docker build -t odoo-mcp:1.0.0 .
docker run -d \
  --name odoo-mcp \
  --env-file .env \
  odoo-mcp:1.0.0
```

## Configuration

### Environment Variables

Create a `.env` file with the following variables:

```bash
# Odoo Connection (Required)
ODOO_URL=https://yourcompany.odoo.com
ODOO_DB=production_db
ODOO_USERNAME=mcp_user
ODOO_PASSWORD=secure_password_here

# MCP Configuration (Optional)
ODOO_MCP_DEFAULT_LIMIT=50
ODOO_MCP_MAX_LIMIT=80

# Logging (Optional)
LOG_LEVEL=INFO
```

### Security Configuration

#### 1. Create Dedicated Odoo User

Create a dedicated Odoo user with appropriate permissions:

```python
# In Odoo: Settings > Users & Companies > Users
user = {
    'name': 'MCP Service User',
    'login': 'mcp_user',
    'email': 'mcp@yourcompany.com',
    'groups_id': [
        (6, 0, [
            # Add appropriate groups
            # base.group_user,  # Employee
            # sales_team.group_sale_manager,  # Sales Manager
            # account.group_account_user,  # Advisor
        ])
    ]
}
```

#### 2. Configure Model Allowlist

Edit `src/odoo_mcp/config.py` to customize allowed models:

```python
DEFAULT_ALLOWED_MODELS: Set[str] = {
    # Add only models you need
    "res.partner",
    "sale.order",
    "account.move",
    # Remove models you don't use
}
```

#### 3. Configure Field Denylist

Edit `src/odoo_mcp/config.py` to customize denied fields:

```python
DEFAULT_DENIED_FIELDS: Set[str] = {
    "company_id",  # Prevent company switching
    "create_uid",  # Audit trail fields
    "create_date",
    "write_uid",
    "write_date",
    "state",  # Workflow state protection
}
```

## Production Deployment

### Option 1: Systemd Service

Create `/etc/systemd/system/odoo-mcp.service`:

```ini
[Unit]
Description=Odoo MCP Server
After=network.target

[Service]
Type=simple
User=odoo-mcp
Group=odoo-mcp
WorkingDirectory=/opt/odoo-mcp
Environment="PATH=/opt/odoo-mcp/venv/bin"
EnvironmentFile=/opt/odoo-mcp/.env
ExecStart=/opt/odoo-mcp/venv/bin/python -m odoo_mcp
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl enable odoo-mcp
sudo systemctl start odoo-mcp
sudo systemctl status odoo-mcp
```

### Option 2: Supervisord

Create `/etc/supervisor/conf.d/odoo-mcp.conf`:

```ini
[program:odoo-mcp]
command=/opt/odoo-mcp/venv/bin/python -m odoo_mcp
directory=/opt/odoo-mcp
user=odoo-mcp
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/var/log/odoo-mcp.log
environment=ODOO_URL="https://yourcompany.odoo.com",ODOO_DB="production_db"
```

Start:

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start odoo-mcp
```

### Option 3: Docker Compose

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  odoo-mcp:
    build: .
    container_name: odoo-mcp
    restart: unless-stopped
    env_file:
      - .env
    volumes:
      - ./logs:/app/logs
    # If using network communication
    # ports:
    #   - "8000:8000"
    networks:
      - odoo-network

networks:
  odoo-network:
    external: true
```

Deploy:

```bash
docker-compose up -d
docker-compose logs -f
```

## Monitoring

### Health Checks

Create a health check endpoint or use the MCP tools:

```bash
# Check if server is running
curl -X POST http://localhost:8000/health \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"ping","params":{},"id":1}'
```

### Logging

Logs are written to stdout/stderr and can be configured:

```python
# In production, configure structured logging
import structlog

logger = structlog.get_logger()
logger.info("server_started", port=8000, environment="production")
```

### Metrics

Collect metrics from log output:

```bash
# Extract performance metrics
grep "METRIC" /var/log/odoo-mcp.log | \
  jq -r 'select(.operation=="odoo_search") | .duration_ms'
```

## Security Best Practices

### 1. Network Security

- Use TLS/SSL for all connections
- Place behind reverse proxy (nginx, caddy)
- Implement IP whitelisting if possible
- Use VPN for internal deployments

### 2. Authentication

- Use dedicated Odoo user with minimal permissions
- Rotate passwords regularly
- Store credentials in secret management system:
  - HashiCorp Vault
  - AWS Secrets Manager
  - Azure Key Vault
  - Environment variables (not in code)

### 3. Access Control

- Limit models in allowlist to minimum required
- Regular audit of model access
- Monitor audit logs for suspicious activity
- Implement rate limiting on Odoo side

### 4. Data Protection

- Enable data redaction for sensitive fields
- Never log passwords/tokens
- Use secure environment for secrets
- Implement log rotation

## Scaling

### Horizontal Scaling

Run multiple instances behind a load balancer:

```yaml
# docker-compose.yml
services:
  odoo-mcp:
    image: odoo-mcp:1.0.0
    deploy:
      replicas: 3
    env_file:
      - .env
```

### Performance Optimization

1. **Connection Pooling**: Configure Odoo to handle multiple connections
2. **Query Limits**: Keep MAX_SEARCH_LIMIT reasonable (default: 80)
3. **Caching**: Cache model schemas and partner lookups
4. **Monitoring**: Track slow operations with metrics

## Troubleshooting

### Common Issues

#### 1. Connection Refused

```bash
# Check Odoo URL is accessible
curl https://yourcompany.odoo.com

# Check network connectivity
ping yourcompany.odoo.com

# Verify credentials
curl -X POST https://yourcompany.odoo.com/web/session/authenticate \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","params":{"db":"test","login":"user","password":"pass"}}'
```

#### 2. Import Errors

```bash
# Verify installation
pip list | grep odoo-mcp

# Reinstall if needed
pip install --force-reinstall odoo-mcp
```

#### 3. Permission Denied

```bash
# Check file permissions
ls -la /opt/odoo-mcp

# Fix permissions
sudo chown -R odoo-mcp:odoo-mcp /opt/odoo-mcp
```

#### 4. Out of Memory

```bash
# Monitor memory usage
docker stats odoo-mcp

# Increase memory limit
docker update --memory 2g odoo-mcp
```

## Backup and Recovery

### Backup Configuration

```bash
# Backup .env file
cp .env .env.backup.$(date +%Y%m%d)

# Backup configuration
tar -czf odoo-mcp-config-$(date +%Y%m%d).tar.gz \
  src/odoo_mcp/config.py \
  src/odoo_mcp/security/
```

### Restore

```bash
# Restore configuration
tar -xzf odoo-mcp-config-20240101.tar.gz

# Restart service
sudo systemctl restart odoo-mcp
```

## Maintenance

### Updates

```bash
# Pull latest changes
git pull origin main

# Update dependencies
pip install -r requirements.txt --upgrade

# Restart service
sudo systemctl restart odoo-mcp
```

### Log Rotation

Create `/etc/logrotate.d/odoo-mcp`:

```
/var/log/odoo-mcp.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 odoo-mcp odoo-mcp
    sharedscripts
    postrotate
        systemctl reload odoo-mcp > /dev/null 2>&1 || true
    endscript
}
```

## Support

For issues and questions:
- 📖 [Documentation](README.md)
- 🐛 [Issue Tracker](https://github.com/nicolasramos/odoo-mcp/issues)
- 💬 [Discussions](https://github.com/nicolasramos/odoo-mcp/discussions)

---

For more information, see:
- [Architecture](ARCHITECTURE.md)
- [QA Runbook](QA_RUNBOOK.md)
- [README](../README.md)
