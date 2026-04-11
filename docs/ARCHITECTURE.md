# Architecture

This document describes the architecture of the Odoo MCP Server.

## Overview

The Odoo MCP Server is built with a **6-layer architecture** that provides separation of concerns, modularity, and maintainability. Each layer has a specific responsibility and clear interfaces with other layers.

## Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Layer 6: Resources                      │
│  Static metadata (schemas, context, summaries) for LLMs    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      Layer 5: Tools                         │
│     38+ MCP tools (CRUD, business operations, etc.)        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                     Layer 4: Services                       │
│     14 domain services (partners, sales, invoices, etc.)   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                     Layer 3: Schemas                        │
│     Pydantic validation for all requests/responses         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Layer 2: Security                        │
│  Guards, policies, audit, and data redaction               │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      Layer 1: Core                          │
│    RPC client, session management, exceptions, etc.        │
└─────────────────────────────────────────────────────────────┘
```

## Layer Details

### Layer 1: Core Layer

**Purpose**: Base technical components for Odoo RPC communication

**Components**:
- `client.py` - Odoo RPC client using standard JSON-RPC endpoints
- `session.py` - Odoo authentication and session management
- `exceptions.py` - Custom exception hierarchy
- `domains.py` - Odoo domain validation
- `serializers.py` - Data serialization for LLM consumption
- `security.py` - Core security validation facade

**Key Features**:
- JSON-RPC communication with Odoo
- Automatic re-authentication
- Standard JSON-RPC calls via `/web/dataset/call_kw/{model}/{method}`
- Domain syntax validation
- Response serialization

### Layer 2: Security Layer

**Purpose**: Security enforcement, audit logging, and data protection

**Components**:
- `guards.py` - Runtime security guards
- `policy.py` - Allowlists and denylists
- `audit.py` - Security audit logging
- `redaction.py` - Sensitive data redaction

**Key Features**:
- **Model Allowlist**: Access restricted to explicitly approved models
- **Field Denylist**: Protected fields cannot be written directly
- **Unlink Blocking**: All delete operations are blocked
- **Action Guards**: Only workflow actions permitted
- **Data Redaction**: Passwords, tokens, secrets redacted
- **Audit Trail**: All operations logged with user context

### Layer 3: Schemas Layer

**Purpose**: Type-safe validation using Pydantic

**Components**:
- `common.py` - Base schemas with user context
- `records.py` - CRUD operation schemas
- `actions.py` - Workflow action schemas
- `business.py` - Business operation schemas (30+ schemas)

**Key Features**:
- Full Pydantic validation
- Type hints for all parameters
- Descriptive field metadata for LLMs
- Default values and constraints
- Nested schema support

### Layer 4: Services Layer

**Purpose**: Domain-specific business logic orchestration

**Services** (14 total):
- `partner_service.py` - Partner/customer operations
- `sales_service.py` - Sales order management
- `purchase_service.py` - Purchase order creation
- `invoice_service.py` - Invoice and payment operations
- `project_service.py` - Project and task management
- `calendar_service.py` - Calendar and event management
- `crm_service.py` - Lead and opportunity management
- `inventory_service.py` - Stock and inventory operations
- `hr_service.py` - HR and timesheet operations
- `helpdesk_service.py` - Helpdesk ticket management
- `contract_service.py` - Contract and line management
- `chatter_service.py` - Chatter and activity management
- `capability_service.py` - System capability queries
- `generic_service.py` - Generic record operations

**Key Features**:
- Business logic encapsulation
- Multi-operation orchestration
- Odoo API abstraction
- Error handling and recovery
- Domain-specific validation

### Layer 5: Tools Layer

**Purpose**: MCP protocol tools that expose functionality to LLMs

**Tool Modules** (12 total):
- `records.py` - Generic CRUD tools
- `actions.py` - Workflow action tools
- `introspection.py` - Schema and capability tools
- `partners.py` - Partner-specific tools
- `sales.py` - Sales-specific tools
- `purchases.py` - Purchase-specific tools
- `accounting.py` - Accounting-specific tools
- `projects.py` - Project-specific tools
- `chatter.py` - Chatter and activity tools
- `generic.py` - Generic record tools
- `business_ops.py` - Complex business operations

**Key Features**:
- 38+ MCP tools registered
- Automatic performance metrics
- Context delegation (sender_id)
- Schema validation
- Error handling

### Layer 6: Resources Layer

**Purpose**: Static metadata and context for LLMs

**Resources** (5 total):
- `odoo://context/odoo18-fields-reference` - Critical Odoo 18 field changes
- `odoo://models` - List of available models
- `odoo://model/{model}/schema` - Model field definitions
- `odoo://record/{model}/{id}/summary` - Record summaries
- `odoo://record/{model}/{id}/chatter_summary` - Chatter history

**Key Features**:
- Static documentation for LLMs
- Model introspection
- Record summarization
- Chatter history
- Odoo 18 compatibility notes

## Data Flow

### Request Flow

```
LLM Request → MCP Protocol → Tool (Layer 5)
    → Service (Layer 4) → Schema Validation (Layer 3)
    → Security Guards (Layer 2) → Odoo Client (Layer 1)
    → Odoo RPC → Native Odoo Security
    → Response → Reverse Path → LLM
```

### Security Flow

```
Tool Request → Schema Validation (Layer 3)
    → Model Allowlist Check (Layer 2)
    → Field Denylist Check (Layer 2)
    → Unlink Blocking (Layer 2)
    → Action Guard (Layer 2)
    → Native Odoo ACL Delegation (Layer 1)
    → Odoo Record Rules
    → Odoo Access Rights
```

## Key Design Principles

### 1. Security by Design

- **Standard Odoo Auth**: All operations run as the authenticated Odoo session user
- **Defense in Depth**: Multiple security layers (allowlists, denylists, guards)
- **Default Deny**: Models not in allowlist are inaccessible
- **Audit Trail**: All operations logged with user context

### 2. Type Safety

- **Pydantic Validation**: All inputs validated at schema layer
- **Type Hints**: Full type coverage for IDE support
- **Descriptive Errors**: Clear validation messages

### 3. Modularity

- **Clear Boundaries**: Each layer has specific responsibility
- **Loose Coupling**: Layers interact through well-defined interfaces
- **Easy Extension**: New tools/services follow established patterns

### 4. Observability

- **Structured Logging**: Consistent log format across all layers
- **Performance Metrics**: Automatic timing for all operations
- **Audit Trail**: Security-relevant events logged

### 5. Odoo Compatibility

- **Odoo 18 Updates**: Field changes (customer_rank, payment_state)
- **Multi-Company**: Full support for company segregation
- **Record Rules**: Native Odoo rules respected

## Technology Stack

### Core Dependencies
- **FastMCP** (`>=0.1.0`) - MCP protocol implementation
- **Pydantic** (`>=2.0.0`) - Data validation
- **Requests** (`>=2.31.0`) - HTTP client for Odoo RPC
- **python-dotenv** (`>=1.0.0`) - Environment configuration

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     LLM Application                        │
└─────────────────────────────────────────────────────────────┘
                              ↓ MCP Protocol
┌─────────────────────────────────────────────────────────────┐
│                  Odoo MCP Server (FastMCP)                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Python Application                      │  │
│  │  ┌────────────────────────────────────────────────┐  │  │
│  │  │         6-Layer Architecture                    │  │  │
│  │  └────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↓ JSON-RPC
┌─────────────────────────────────────────────────────────────┐
│                    Odoo 18 Instance                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │      /web/dataset/call_kw/{model}/{method}          │  │
│  │            (Standard Odoo JSON-RPC)                 │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Odoo ORM & Security                     │  │
│  │  • Record Rules                                      │  │
│  │  • Access Rights (ACL)                               │  │
│  │  • Multi-Company                                     │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Extension Points

### Adding New Tools

1. Create schema in `schemas/business.py`
2. Create service in `services/` if complex
3. Create tool function in `tools/`
4. Register in `server.py` with `@mcp.tool()`

### Adding New Services

1. Create service file in `services/`
2. Implement business logic using OdooClient
3. Add security guards as needed
4. Create corresponding tools in `tools/`

### Adding New Models

1. Add to `DEFAULT_ALLOWED_MODELS` in `config.py`
2. Update documentation
3. Add tests for new model operations
4. Consider adding model-specific tools

## Performance Considerations

### Optimization Strategies

- **Connection Pooling**: Reuse Odoo sessions
- **Lazy Loading**: Load schemas on demand
- **Response Caching**: Cache schema metadata
- **Query Limits**: Enforce MAX_SEARCH_LIMIT (80 records)

### Monitoring

- **Metrics**: All operations timed with `@measure_time`
- **Logging**: Structured logs for analysis
- **Audit**: Security events logged separately

## Security Best Practices

1. **Never Bypass Guards**: All operations must go through security layer
2. **Respect Allowlists**: Only add models that are truly necessary
3. **Validate Inputs**: Always use schemas for validation
4. **Log Audits**: Security-relevant operations must be logged
5. **Redact Secrets**: Never return passwords/tokens in responses
6. **Use Standard Odoo Auth**: Leverage Odoo's built-in ACL and Record Rules

---

For more information, see:
- [Deployment Guide](DEPLOYMENT.md)
- [QA Runbook](QA_RUNBOOK.md)
- [README](../README.md)
