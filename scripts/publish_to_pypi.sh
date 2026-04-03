#!/bin/bash
set -e

echo "🚀 Publishing Odoo MCP Server to PyPI"
echo "===================================="

# Check if we're on the right branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ]; then
    echo "❌ Error: Not on main branch. Current branch: $BRANCH"
    exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Error: Working directory is not clean"
    git status
    exit 1
fi

# Get version
VERSION=$(grep '^version' pyproject.toml | head -1 | awk -F'"' '{print $2}')
echo "📦 Publishing version: $VERSION"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/ build/ *.egg-info

# Build the package
echo "🔨 Building package..."
python -m build

# Check the package
echo "🔍 Checking package..."
twine check dist/*

# Show what will be published
echo "📋 Files to publish:"
ls -lh dist/

# Ask for confirmation
read -p "🎯 Publish to PyPI? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Publish to PyPI
    echo "⬆️  Publishing to PyPI..."
    twine upload dist/*

    # Create git tag
    echo "🏷️  Creating git tag..."
    git tag -a "v$VERSION" -m "Release v$VERSION"
    git push origin "v$VERSION"

    echo "✅ Successfully published v$VERSION to PyPI!"
    echo "🔗 Package: https://pypi.org/project/odoo-mcp/"
else
    echo "❌ Publication cancelled"
    exit 1
fi
