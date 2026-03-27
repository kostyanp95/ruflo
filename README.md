# @claude-flow/cli (ruflo)

Patched build of `@claude-flow/cli` with Windows compatibility fixes.

## Setup on a new machine

```powershell
# 1. Clone
git clone https://github.com/kostyanp95/ruflo.git D:\ruflo-cli
cd D:\ruflo-cli
npm link

# 2. Install ruflo globally and link
npm install -g ruflo
cd (npm root -g)\ruflo
npm link @claude-flow/cli
```

## What's patched

- Windows: `which` -> `where` for claude CLI detection
- Windows: resolve `claude.cmd` -> `node cli.js` to avoid shell argument corruption
- Windows: ESM-compatible imports (`accessSync`, `dirname` instead of `require()`)
- Hive Mind prompt: mandatory MCP integration rules
