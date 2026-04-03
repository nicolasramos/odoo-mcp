# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-04-03

### Added
- Initial release of Odoo MCP Server
- 6-layer architecture (Core, Security, Observability, Schemas, Tools, Services)
- 38 MCP tools for Odoo operations
- 14 domain services for business logic
- 5 dynamic MCP resources
- Native Odoo security delegation via `/odooclaw/call_kw_as_user`
- Model allowlist with 28 approved models
- Field denylist for protected fields
- Complete security guards (model access, write fields, unlink, actions)
- Structured logging and performance metrics
- Audit trail for all operations
- Data redaction for sensitive values
- Comprehensive test suite (6 test files + E2E runner)
- Full Odoo 18 compatibility (customer_rank, supplier_rank, payment_state)
- Multi-company support
- Type-safe Pydantic validation
- Documentation (README, Architecture, Deployment, QA Runbook)
- Configuration templates (.env.example, pyproject.toml)
- Development tools (pytest, black, ruff, mypy)

### Security
- Native Odoo ACL delegation
- Model allowlist enforcement
- Field-level write protection
- Complete unlink blocking
- Workflow action validation
- Sensitive data redaction
- Audit logging

### Documentation
- Comprehensive README with installation and usage
- Architecture documentation
- Deployment guide
- QA Runbook (515 lines)
- API documentation for all 38 tools
- Configuration examples

### Testing
- Unit tests for core functionality
- Integration tests for business logic
- E2E test runner with real Odoo instance
- Security tests
- Coverage reporting (>80% target)

## [Unreleased]

### Planned Features
- Additional Odoo model support
- Enhanced error handling
- Performance optimizations
- Additional business services
- Web UI for testing tools
- Docker container support

---

[1.0.0]: https://github.com/nicolasramos/odoo-mcp/releases/tag/v1.0.0
