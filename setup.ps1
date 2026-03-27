# Ruflo Setup Script (Windows PowerShell)
# Installs patched ruflo globally via npm link

$ErrorActionPreference = "Stop"

Write-Host "`n=== Ruflo Setup ===" -ForegroundColor Cyan

# 1. Check prerequisites
Write-Host "`n[1/4] Checking prerequisites..." -ForegroundColor Yellow
$nodeVersion = (node --version 2>$null)
if (-not $nodeVersion) {
    Write-Host "ERROR: Node.js not found. Install Node.js 20+ first." -ForegroundColor Red
    exit 1
}
Write-Host "  Node.js: $nodeVersion" -ForegroundColor Green

$npmVersion = (npm --version 2>$null)
Write-Host "  npm: $npmVersion" -ForegroundColor Green

# 2. Install CLI dependencies (skip if node_modules already present — offline mode)
Write-Host "`n[2/4] Installing CLI dependencies..." -ForegroundColor Yellow
if (Test-Path "$PSScriptRoot\cli\node_modules") {
    Write-Host "  node_modules found — skipping install (offline mode)" -ForegroundColor Green
} else {
    Push-Location "$PSScriptRoot\cli"
    npm install --omit=dev --omit=optional --ignore-scripts --legacy-peer-deps 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Warning: some deps failed — MCP may not work fully" -ForegroundColor DarkYellow
    }
    Pop-Location
}

# 3. Link ruflo globally
Write-Host "`n[3/4] Linking ruflo globally..." -ForegroundColor Yellow
Push-Location $PSScriptRoot
npm link 2>&1
Pop-Location

# 4. Verify
Write-Host "`n[4/4] Verifying installation..." -ForegroundColor Yellow
$rufloPath = (Get-Command ruflo -ErrorAction SilentlyContinue).Source
if ($rufloPath) {
    Write-Host "  ruflo found at: $rufloPath" -ForegroundColor Green
    ruflo --version 2>$null
    Write-Host "`n=== Setup complete! ===" -ForegroundColor Cyan
    Write-Host "Run 'ruflo doctor' to verify, or 'ruflo init' in your project." -ForegroundColor White
} else {
    Write-Host "  WARNING: ruflo not found in PATH" -ForegroundColor Red
    Write-Host "  Try reopening your terminal, or check npm global bin:" -ForegroundColor Yellow
    npm config get prefix
}
