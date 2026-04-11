# OdooClaw MCP

Standalone MCP (Model Context Protocol) server for Odoo 18 over `stdio`.

**MCP name:** `io.github.nicolasramos/odoo-mcp`  
**PyPI package:** `odooclaw-mcp`  
**Official CLI:** `odooclaw-mcp`

Backward-compatible aliases are also installed:

- `odoo-mcp`
- `odoo-mcp-server`
- `odoo-18-mcp-server`

## Quick Start

### 1) Install

```bash
pip install odooclaw-mcp
```

From source:

```bash
git clone https://github.com/nicolasramos/odooclaw-mcp.git
cd odooclaw-mcp
pip install -e .
```

### 2) Configure environment

```bash
cp .env.example .env
```

Required:

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

### 3) Validate and run

```bash
odooclaw-mcp --check-config
odooclaw-mcp
```

Alternative:

```bash
python -m odoo_mcp
```

## MCP Client Configuration (stdio)

```json
{
  "mcpServers": {
    "odoo": {
      "command": "odooclaw-mcp",
      "env": {
        "ODOO_URL": "https://yourcompany.odoo.com",
        "ODOO_DB": "your_database",
        "ODOO_USERNAME": "your_username",
        "ODOO_PASSWORD": "your_password",
        "ODOO_MCP_DEFAULT_LIMIT": "50",
        "ODOO_MCP_MAX_LIMIT": "80"
      }
    }
  }
}
```

## Scope

- 38+ MCP tools for Odoo operations (CRUD + business actions)
- Pydantic validation for all tool payloads
- Odoo 18 compatibility helpers (customer_rank / supplier_rank / payment_state)
- Security guards (model allowlist, denylisted fields, action guard, unlink blocked)
- Structured logging and audit actions

## Security Model

The server uses standard Odoo JSON-RPC endpoints and executes operations as the
configured Odoo session user.

For production, use a dedicated least-privilege Odoo account.

## Production Notes

- This is a `stdio` MCP server, not an HTTP API service.
- Docker/Compose support is mainly for packaging or controlled runtime scenarios.
- In normal usage, your MCP client launches the server process directly.
- Keep Odoo credentials in environment variables or a secrets manager.

## Known Limitations

- One Odoo credential context per MCP process.
- `ODOO_DB` is currently required by the authentication flow.
- Some tools require specific Odoo apps/modules (CRM, Helpdesk, Project, etc.).
- Designed for Odoo 18 field semantics.

## Development

```bash
pip install -e .[dev]
ruff check src tests
black --check src tests
mypy src --ignore-missing-imports
pytest tests -v
python -m build
twine check dist/*
```

## Docs

- [Architecture](docs/ARCHITECTURE.md)
- [Deployment](docs/DEPLOYMENT.md)
- [QA Runbook](docs/QA_RUNBOOK.md)

## License

MIT - see [LICENSE](LICENSE).
