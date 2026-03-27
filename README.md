# ruflo (patched)

Patched build of `@claude-flow/cli` + `ruflo` wrapper with Windows compatibility fixes.

## What's patched

- **hive-mind spawn**: `which` -> `where` for claude CLI detection on Windows
- **hive-mind spawn**: resolve `claude.cmd` -> `node cli.js` to avoid shell argument corruption
- **hive-mind spawn**: dynamic MCP server name detection from `.mcp.json` (fixes `mcp__ruflo__*` vs `mcp__claude-flow__*` mismatch)
- **headless worker**: `shell: true` on Windows for child_process.spawn
- **statusline**: cross-platform `node "$CLAUDE_PROJECT_DIR/..."` instead of `sh -c` wrapper
- **ESM imports**: `accessSync`, `dirname` via `import` instead of `require()`

## Quick Setup

### With internet (clone from GitHub)

```bash
git clone https://github.com/kostyanp95/ruflo.git
cd ruflo
```

**Windows (PowerShell):**
```powershell
.\setup.ps1
```

**Linux / macOS / WSL:**
```bash
chmod +x setup.sh
./setup.sh
```

### Without internet (offline transfer)

**On source machine:**
```bash
cd ruflo
# Create offline bundle with all dependencies
npm install --prefix cli --omit=dev --ignore-scripts
tar -czf ruflo-offline.tar.gz --exclude='.git' .
# Copy ruflo-offline.tar.gz to USB drive
```

**On target machine:**
```bash
mkdir -p ~/ruflo
tar xzf ruflo-offline.tar.gz -C ~/ruflo
cd ~/ruflo
npm link
```

### Manual setup (any OS)

```bash
# 1. Install CLI dependencies (needs internet once)
cd cli
npm install --omit=dev --ignore-scripts

# 2. Link ruflo globally
cd ..
npm link

# 3. Verify
ruflo --version
```

## Usage in projects

### Initialize a project

```bash
cd your-project
ruflo init --wizard
```

This creates `.mcp.json` and `.claude/settings.json` with proper MCP configuration.

### Fix existing project (MCP not working)

If `ruflo hive-mind spawn --claude` doesn't call MCP tools, update `.mcp.json`:

```json
{
  "mcpServers": {
    "claude-flow": {
      "command": "node",
      "args": ["<path-to-ruflo>/cli/bin/cli.js", "mcp", "start"],
      "env": {
        "CLAUDE_FLOW_MODE": "v3",
        "CLAUDE_FLOW_HOOKS_ENABLED": "true"
      }
    }
  }
}
```

Replace `<path-to-ruflo>` with the actual path (e.g., `D:/ruflo` or `~/ruflo`).

### Spawn hive mind

```bash
ruflo hive-mind spawn --claude
```

The spawned Claude Code will use `mcp__claude-flow__*` tools (or `mcp__ruflo__*` depending on your `.mcp.json` server name).

## Structure

```
ruflo/
├── bin/ruflo.js        # CLI entry point (wrapper)
├── cli/                # @claude-flow/cli (patched)
│   ├── bin/cli.js      # Direct CLI entry
│   ├── dist/src/       # Compiled JS (runtime)
│   └── package.json
├── setup.ps1           # Windows setup
├── setup.sh            # Linux/macOS setup
├── package.json
└── README.md
```

## Updating

To pull latest patches:
```bash
cd ruflo
git pull
# Re-run setup if CLI deps changed
cd cli && npm install --omit=dev --ignore-scripts
```
