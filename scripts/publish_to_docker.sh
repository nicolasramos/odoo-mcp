#!/bin/bash
set -e

echo "🐳 Publishing Odoo MCP Server to Docker Hub"
echo "==========================================="

# Get version
VERSION=$(grep '^version' pyproject.toml | head -1 | awk -F'"' '{print $2}')
echo "📦 Publishing version: $VERSION"

# Build images
echo "🔨 Building Docker images..."
docker build -t nicolasramos/odoo-mcp:$VERSION .
docker tag nicolasramos/odoo-mcp:$VERSION nicolasramos/odoo-mcp:latest

# Show images
echo "📋 Built images:"
docker images | grep odoo-mcp

# Ask for confirmation
read -p "🎯 Publish to Docker Hub? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Login to Docker Hub
    echo "🔐 Logging in to Docker Hub..."
    docker login

    # Push images
    echo "⬆️  Pushing images to Docker Hub..."
    docker push nicolasramos/odoo-mcp:$VERSION
    docker push nicolasramos/odoo-mcp:latest

    echo "✅ Successfully published to Docker Hub!"
    echo "🔗 Image: https://hub.docker.com/r/nicolasramos/odoo-mcp"
else
    echo "❌ Publication cancelled"
    exit 1
fi
