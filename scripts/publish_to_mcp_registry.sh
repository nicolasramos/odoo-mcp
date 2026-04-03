#!/bin/bash
set -e

echo "🚀 Publishing Odoo MCP Server to MCP Registry"
echo "================================================"
echo ""

# Check if server.json exists
if [ ! -f "server.json" ]; then
    echo "❌ Error: server.json not found"
    exit 1
fi

echo "📋 Found server.json configuration"
echo ""

# Clone the registry repository to get the publisher CLI
echo "📥 Downloading MCP Publisher CLI..."
cd /tmp
rm -rf registry
git clone https://github.com/modelcontextprotocol/registry.git
cd registry

# Build the publisher CLI
echo "🔨 Building MCP Publisher CLI..."
make publisher

if [ ! -f "./bin/mcp-publisher" ]; then
    echo "❌ Error: Failed to build mcp-publisher"
    exit 1
fi

echo "✅ MCP Publisher CLI built successfully"
echo ""

# Go back to the odoo-mcp directory
cd /Users/Shared/PROYECTOS/odoo-mcp

# Publish using the CLI
    echo "🎯 Publishing to MCP Registry..."
    echo ""
    echo "This will:"
    echo "1. Authenticate with GitHub OAuth"
    echo "2. Validate your server.json"
    echo "3. Publish io.github.nicolasramos.odoo-mcp to the registry"
    echo ""
    read -p "Continue? (y/N) " -n 1 -r
    echo
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Run the publisher with full path
        /tmp/registry/bin/mcp-publisher login github

    echo ""
    echo "✅ Successfully published to MCP Registry!"
    echo ""
    echo "🔍 View your server at: https://registry.modelcontextprotocol.io/servers/io.github.nicolasramos.odoo-mcp"
else
    echo "❌ Publication cancelled"
    exit 1
fi
