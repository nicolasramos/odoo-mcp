# Deployment Guide

## Overview

`odoo-mcp` is a stdio MCP server for Odoo 18 using standard Odoo JSON-RPC.

- Package: `odoo-mcp`
- Official CLI: `odoo-mcp`
- Python: 3.11+

Backward-compatible aliases:

- `odoo-mcp-server`
- `odoo-18-mcp-server`

## Install

```bash
pip install odoo-mcp
```

From source:

```bash
git clone https://github.com/nicolasramos/odoo-mcp.git
cd odoo-mcp
pip install -e .
```

## Required env vars

```env
ODOO_URL=https://yourcompany.odoo.com
ODOO_DB=your_database
ODOO_USERNAME=your_username
ODOO_PASSWORD=your_password
```

Optional:

```env
ODOO_MCP_DEFAULT_LIMIT=50
ODOO_MCP_MAX_LIMIT=80
LOG_LEVEL=INFO
```

## Run

```bash
odoo-mcp --check-config
odoo-mcp
```

Alternative:

```bash
python -m odoo_mcp
```

## MCP client config (stdio)

```json
{
  "mcpServers": {
    "odoo": {
      "command": "odoo-mcp",
      "env": {
        "ODOO_URL": "https://yourcompany.odoo.com",
        "ODOO_DB": "your_database",
        "ODOO_USERNAME": "your_username",
        "ODOO_PASSWORD": "your_password"
      }
    }
  }
}
```

## Docker

```bash
docker build -t odoo-mcp .
docker run --rm -it \
  -e ODOO_URL=https://yourcompany.odoo.com \
  -e ODOO_DB=your_database \
  -e ODOO_USERNAME=your_username \
  -e ODOO_PASSWORD=your_password \
  odoo-mcp
```

Or:

```bash
docker compose up
```

> Note: stdio transport means Docker is mainly for controlled runtime/packaging,
> not for a typical long-running HTTP service.

## Security notes

- Use a dedicated least-privilege Odoo user.
- Model access is restricted by allowlist.
- Sensitive write fields are blocked.
- Unlink is blocked.
- Action method names are validated.
