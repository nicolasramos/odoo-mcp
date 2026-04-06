# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-04-06

### BREAKING CHANGES
- Removed dependency on custom `/odooclaw/call_kw_as_user` endpoint
- Server now works with ANY standard Odoo 18 instance without custom modules
- All RPC operations execute as the authenticated session user

### Changed
- Simplified `OdooClient.call_kw()` to use only standard Odoo JSON-RPC endpoints
- Kept `sender_id` in tool payloads as optional audit/context metadata for backward compatibility
- Updated security model documentation to reflect standard Odoo authentication
- Changed title from "Conectando Claude con Odoo" to "Conectando LLMs con Odoo"

### Removed
- Cleaned up residual dependencies (reduced from 50+ to 11 packages):
  - langchain-core, langchain-openai, langgraph
  - pandas, numpy, numpy-financial
  - openpyxl, pypdf, pdf2image, pytesseract
  - schwifty, xlrd

### Fixed
- Fixed Dockerfile to install from source instead of non-existent PyPI package
- Fixed mypy overrides to remove langchain/langgraph references
- Removed all AI assistant references from documentation

### Security
- Updated documentation to clarify that server uses standard Odoo endpoints only
- Added security best practices section for production deployments
- Emphasized need for dedicated Odoo user with minimal permissions

### Documentation
- Updated README.md to remove custom endpoint references
- Updated DEPLOYMENT.md with standard Odoo endpoint information
- Added security best practices for production use
- Updated all references to use generic "LLMs" instead of specific AI models

### Migration Guide from 1.x to 2.0.0

**If you were using version 1.x:**

1. **Update your dependencies:**
   ```bash
   pip install --upgrade odoo-mcp==2.0.0
   ```

2. **Remove custom Odoo modules:**
   - You no longer need the `mail_bot_odooclaw` module
   - The server now uses standard Odoo JSON-RPC endpoints

3. **Update your configuration:**
   - The same `.env` configuration works
   - Create a dedicated Odoo user with appropriate permissions

4. **No code changes needed:**
   - All MCP tools work exactly the same
   - Security is now enforced through Odoo's native ACL instead

**Benefits of upgrading:**
- ✅ Works with any standard Odoo 18 instance
- ✅ Fewer dependencies (faster install, smaller footprint)
- ✅ Simpler architecture (less to maintain)
- ✅ Better documentation
- ✅ No custom modules required

---

[2.0.0]: https://github.com/nicolasramos/odoo-mcp/releases/tag/v2.0.0

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
