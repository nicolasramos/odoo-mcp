# Dockerfile for odoo-18-mcp-server
FROM python:3.11-slim

LABEL maintainer="Nicolás Ramos <nicolasramos@users.noreply.github.com>"
LABEL description="MCP server for Odoo 18 with 38 business tools"
LABEL version="1.0.1"
LABEL org.opencontainers.image.source="https://github.com/nicolasramos/odoo-mcp"
LABEL org.opencontainers.image.title="odoo-18-mcp-server"
LABEL org.opencontainers.image.description="Modular, type-safe, and secure MCP server for interacting with Odoo 18 ORM"

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install the package from PyPI
RUN pip install --no-cache-dir odoo-18-mcp-server==2.0.0

# Create a non-root user
RUN useradd -m -u 1000 mcpuser && \
    mkdir -p /app && \
    chown -R mcpuser:mcpuser /app

USER mcpuser

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV ODOO_MCP_DEFAULT_LIMIT=50
ENV ODOO_MCP_MAX_LIMIT=80

# Health check (verify package is importable)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import odoo_mcp" || exit 1

# Run the MCP server using the installed entry point
ENTRYPOINT ["odoo-18-mcp-server"]
