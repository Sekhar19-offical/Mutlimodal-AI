# 🏥 Connection Doctor & Fixer
Write-Host "Checking system for connection issues..." -ForegroundColor Cyan

# 1. Kill any existing backend processes on port 8000
Write-Host "Cleaning up port 8000..." -ForegroundColor Yellow
$processes = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
if ($processes) {
    foreach ($p in $processes) {
        Stop-Process -Id $p -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Stopped process $p" -ForegroundColor Green
    }
} else {
    Write-Host "✅ Port 8000 is clear" -ForegroundColor Green
}

# 2. Check & Fix Ollama
Write-Host "Checking Ollama..." -ForegroundColor Yellow
$ollama = Get-Process -Name "ollama" -ErrorAction SilentlyContinue
if (-not $ollama) {
    Write-Host "❌ Ollama is NOT running. Attempting to start it..." -ForegroundColor Red
    # Try common installation paths
    $ollamaApp = "$env:LOCALAPPDATA\Ollama\ollama app.exe"
    if (Test-Path $ollamaApp) {
        Start-Process $ollamaApp
        Write-Host "🚀 Ollama App started. It may take a moment to initialize." -ForegroundColor Green
    } else {
        # Fallback to command line
        Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden
        Write-Host "🚀 'ollama serve' started in background." -ForegroundColor Green
    }
} else {
    Write-Host "✅ Ollama is running" -ForegroundColor Green
}

# 3. Try to start the backend
Write-Host "Restarting Backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-File", "$PSScriptRoot\backend\start-backend.ps1"

Write-Host "`nDone! Wait a few seconds for the backend window to initialize, then refresh your browser." -ForegroundColor Cyan
