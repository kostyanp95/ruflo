#!/bin/bash
# Ruflo Setup Script (Linux / macOS / WSL)
# Installs patched ruflo globally via npm link

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "=== Ruflo Setup ==="

# 1. Check prerequisites
echo ""
echo "[1/4] Checking prerequisites..."
NODE_V=$(node --version 2>/dev/null || true)
if [ -z "$NODE_V" ]; then
    echo "  ERROR: Node.js not found. Install Node.js 20+ first."
    exit 1
fi
echo "  Node.js: $NODE_V"
echo "  npm: $(npm --version)"

# 2. Install CLI dependencies (skip if node_modules already present — offline mode)
echo ""
echo "[2/4] Installing CLI dependencies..."
if [ -d "$SCRIPT_DIR/cli/node_modules" ]; then
    echo "  node_modules found — skipping install (offline mode)"
else
    cd "$SCRIPT_DIR/cli"
    npm install --omit=dev --omit=optional --ignore-scripts --legacy-peer-deps 2>/dev/null || echo "  Warning: some deps failed"
fi

# 3. Link ruflo globally
echo ""
echo "[3/4] Linking ruflo globally..."
cd "$SCRIPT_DIR"
npm link

# 4. Verify
echo ""
echo "[4/4] Verifying installation..."
RUFLO_PATH=$(which ruflo 2>/dev/null || true)
if [ -n "$RUFLO_PATH" ]; then
    echo "  ruflo found at: $RUFLO_PATH"
    ruflo --version 2>/dev/null || true
    echo ""
    echo "=== Setup complete! ==="
    echo "Run 'ruflo doctor' to verify, or 'ruflo init' in your project."
else
    echo "  WARNING: ruflo not found in PATH"
    echo "  Try: export PATH=\"\$(npm config get prefix)/bin:\$PATH\""
fi
