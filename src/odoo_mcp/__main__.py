"""Main entry point for running the Odoo MCP server as a module."""

from odoo_mcp.server import mcp

if __name__ == "__main__":
    mcp.run()
