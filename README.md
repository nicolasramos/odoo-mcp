# Odoo MCP Server

A modular, type-safe, and secure MCP (Model Context Protocol) server for interacting with Odoo 18 ORM.

**mcp-name: io.github.nicolasramos/odoo-mcp**

[![PyPI version](https://badge.fury.io/py/odoo-18-mcp-server.svg)](https://badge.fury.io/py/odoo-18-mcp-server)
[![Python Versions](https://img.shields.io/pypi/pyversions/odoo-18-mcp-server.svg)](https://pypi.org/project/odoo-18-mcp-server/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

Odoo MCP Server provides a comprehensive interface to Odoo 18 through the MCP protocol, enabling LLMs (Large Language Models) to interact with Odoo in a secure, controlled manner. The server replaces monolithic CRUD access with granular tools for specific business operations while respecting Odoo's native security model.

## Architecture

The server is built with a **6-layer architecture**:

1. **Core Layer**: RPC client, session management, exceptions, domain validation, and serialization
2. **Security Layer**: Allowlists, denylists, guards, audit logging, and data redaction
3. **Observability Layer**: Structured logging, performance metrics, and audit trails
4. **Schemas Layer**: Pydantic validation for all requests
5. **Tools Layer**: 38+ MCP tools for specific operations (CRUD, business logic)
6. **Services Layer**: 14 domain services orchestrating complex operations

## Key Features

- **🔒 Security-First**: Native Odoo ACL delegation, allowlists, denylists, and field-level protection
- **🏢 Multi-Company**: Full support for Odoo's multi-company architecture
- **📊 Observability**: Built-in logging, metrics, and audit trails
- **✅ Type-Safe**: Full Pydantic validation on all inputs/outputs
- **🧪 Well-Tested**: Comprehensive test suite with E2E validation
- **🔧 Modular**: Easy to extend with new tools and services
- **📝 Odoo 18 Compatible**: Updated for latest Odoo 18 field changes (customer_rank, supplier_rank, payment_state)

## Installation

### From PyPI (Recommended)

```bash
pip install odoo-18-mcp-server
```

### From Source

```bash
git clone https://github.com/nicolasramos/odoo-mcp.git
cd odoo-mcp
pip install -e .
```

### Development Installation

```bash
pip install -r requirements-dev.txt
pre-commit install
```

## Configuration

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit `.env` with your Odoo credentials:

```bash
ODOO_URL=https://yourcompany.odoo.com
ODOO_DB=database_name
ODOO_USERNAME=admin
ODOO_PASSWORD=your_password
ODOO_MCP_DEFAULT_LIMIT=50
ODOO_MCP_MAX_LIMIT=80
```

## Usage

### Running the Server

```bash
# As a Python module
python -m odoo_mcp

# Or using the installed command
odoo-mcp
```

### Available MCP Tools

The server provides **38 tools** organized by domain:

#### Core CRUD
- `odoo_search` - Search records with domain filters
- `odoo_read` - Read specific record IDs
- `odoo_create` - Create new records
- `odoo_write` - Update existing records
- `odoo_invoke_action` - Execute workflow actions

#### Partners & Customers
- `odoo_find_partner` - Find or create partners
- `odoo_get_partner_summary` - Get partner overview with related documents

#### Sales & CRM
- `odoo_find_sale_order` - Search sale orders
- `odoo_get_sale_order_summary` - Get detailed order information
- `odoo_create_sale_order` - Create new sale orders
- `odoo_confirm_sale_order` - Confirm draft orders
- `odoo_create_lead` - Create CRM leads/opportunities

#### Projects & Tasks
- `odoo_find_task` - Search project tasks
- `odoo_create_task` - Create new tasks
- `odoo_update_task` - Update task status/assignment
- `odoo_log_timesheet` - Log work time

#### Activities & Chatter
- `odoo_create_activity` - Schedule activities
- `odoo_list_pending_activities` - List pending activities
- `odoo_mark_activity_done` - Complete activities
- `odoo_post_chatter_message` - Post messages to records

#### Accounting & Finance
- `odoo_find_pending_invoices` - Find unpaid invoices
- `odoo_get_invoice_summary` - Get invoice details
- `odoo_register_payment` - Record payments
- `odoo_create_vendor_invoice` - Create vendor bills

#### Purchasing
- `odoo_create_purchase_order` - Create purchase orders

#### Calendar
- `odoo_create_calendar_event` - Create meetings/appointments

#### Inventory
- `odoo_get_product_stock` - Check product quantities

#### Helpdesk
- `odoo_create_helpdesk_ticket` - Create support tickets
- `odoo_create_helpdesk_ticket_from_partner` - Create tickets from partners

#### Contracts
- `odoo_create_contract_line` - Add contract lines
- `odoo_replace_contract_line` - Replace contract lines
- `odoo_close_contract_line` - Close contract lines

#### Introspection
- `odoo_get_model_schema` - Get model field definitions
- `odoo_get_capabilities` - List available operations
- `odoo_get_record_summary` - Get record overview

### MCP Resources

The server exposes **5 dynamic resources**:

- `odoo://context/odoo18-fields-reference` - Critical Odoo 18 field changes
- `odoo://models` - List of available models
- `odoo://model/{model}/schema` - Model field definitions
- `odoo://record/{model}/{id}/summary` - Record summaries
- `odoo://record/{model}/{id}/chatter_summary` - Chatter history

## Security

### Native Odoo Security

The server authenticates with Odoo using standard JSON-RPC endpoints and executes all operations as the configured user. This ensures:

- ✅ Record Rules are respected
- ✅ Access Rights (ACL) are enforced
- ✅ Company segregation is maintained
- ✅ User permissions are honored

**Important**: For production use, create a dedicated Odoo user with minimal required permissions for the specific models and operations you need.

### MCP Security Layers

1. **Model Allowlist**: Only 28 approved models can be accessed
2. **Field Denylist**: Protected fields (company_id, state, etc.) cannot be written directly
3. **Unlink Blocking**: All delete operations are blocked
4. **Action Guards**: Only workflow actions (action_*, button_*) are permitted
5. **Data Redaction**: Sensitive values (passwords, tokens) are redacted from responses

## Development

### Running Tests

```bash
# Unit tests
pytest tests/ -v

# With coverage
pytest tests/ --cov=src/odoo_mcp --cov-report=html

# E2E tests (requires real Odoo instance)
python tests/qa_e2e_runner.py
```

### Code Quality

```bash
# Format code
black src/ tests/

# Lint
ruff check src/ tests/

# Type check
mypy src/
```

## Documentation

- [Architecture](docs/ARCHITECTURE.md) - Detailed system architecture
- [Deployment Guide](docs/DEPLOYMENT.md) - Production deployment instructions
- [QA Runbook](docs/QA_RUNBOOK.md) - Comprehensive testing guide

## Examples

See the `examples/` directory for usage examples:
- `basic_usage.py` - Basic MCP interactions
- `mcp_config.json` - MCP client configuration

## Odoo 18 Compatibility

This server is designed for **Odoo 18** and includes critical updates for field changes:

### res.partner Changes
- ❌ `customer=True` → ✅ `customer_rank > 0`
- ❌ `supplier=True` → ✅ `supplier_rank > 0`
- ❌ `is_customer=True` → **Field does not exist**

### account.move Changes
- ❌ `state=open` → ✅ `state=posted` AND `payment_state=not_paid`
- ❌ `state=paid` → ✅ `state=posted` AND `payment_state=paid`

**Always use** `odoo_find_pending_invoices` - it handles Odoo 18 domains correctly.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow PEP 8 style guidelines
- Add tests for new features
- Update documentation for API changes
- Use type hints where appropriate
- Keep security in mind - allowlist models, validate inputs

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/nicolasramos/odoo-mcp/issues)
- 💬 [Discussions](https://github.com/nicolasramos/odoo-mcp/discussions)

## Author

**Nicolás Ramos** - [GitHub](https://github.com/nicolasramos)

## Acknowledgments

Built with:
- [FastMCP](https://github.com/jlowin/fastmcp) - MCP framework
- [Pydantic](https://docs.pydantic.dev/) - Data validation
- [Odoo](https://www.odoo.com/) - ERP system
