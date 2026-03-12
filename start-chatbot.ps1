# Multimodal Chatbot Startup Script
# This script starts all required services for the chatbot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Multimodal Chatbot Startup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is available
Write-Host "[1/6] Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python found: $pythonVersion" -ForegroundColor Green
}
catch {
    Write-Host "✗ Python not found. Please install Python 3.8 or higher." -ForegroundColor Red
    exit 1
}

# Check if Node.js is available
Write-Host "[2/6] Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>&1
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
}
catch {
    Write-Host "✗ Node.js not found. Please install Node.js 16 or higher." -ForegroundColor Red
    exit 1
}

# Check if Ollama is running
Write-Host "[3/6] Checking Ollama service..." -ForegroundColor Yellow
try {
    $ollamaCheck = Invoke-WebRequest -Uri "http://localhost:11434/api/tags" -Method GET -TimeoutSec 2 -ErrorAction SilentlyContinue -UseBasicParsing
    Write-Host "✓ Ollama is running and ready" -ForegroundColor Green
}
catch {
    Write-Host "⚠ Ollama is not running (Gemini will be used exclusively)" -ForegroundColor Yellow
}

# Install backend dependencies if needed
Write-Host "[4/6] Checking backend dependencies..." -ForegroundColor Yellow
Set-Location "d:\chatbot\backend"
if (-not (Test-Path ".venv")) {
    Write-Host "Creating Python virtual environment..." -ForegroundColor Yellow
    python -m venv .venv
}
. .\.venv\Scripts\Activate.ps1
Write-Host "Installing/updating backend dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt --quiet
Write-Host "✓ Backend dependencies ready" -ForegroundColor Green

# Install frontend dependencies if needed
Write-Host "[5/6] Checking frontend dependencies..." -ForegroundColor Yellow
Set-Location "d:\chatbot\frontend"
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    npm install
}
Write-Host "✓ Frontend dependencies ready" -ForegroundColor Green

# Start services
Write-Host "[6/6] Starting services..." -ForegroundColor Yellow
Write-Host ""

# ----------------- CLEANUP -----------------
Write-Host "Cleaning up old processes..." -ForegroundColor Gray
$ports = @(3000, 8000, 8001)
foreach ($port in $ports) {
    try {
        $procIds = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess
        if ($procIds) {
            foreach ($pId in $procIds) {
                Stop-Process -Id $pId -Force -ErrorAction SilentlyContinue
                Write-Host "  Cleared port $port" -ForegroundColor Gray
            }
        }
    }
    catch { }
}
# -------------------------------------------

# Start AI Agent Service (Port 8001)
Write-Host "Starting AI Agent Service on port 8001..." -ForegroundColor Cyan
Set-Location "d:\chatbot\backend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'd:\chatbot\backend'; .\.venv\Scripts\Activate.ps1; python hybrid_rag_backend.py" -WindowStyle Normal

# Wait for models
Write-Host "Waiting for AI models to initialize (~20s)..." -ForegroundColor Magenta
Start-Sleep -Seconds 20

# Start Main Backend (Port 8000)
Write-Host "Starting Main Backend on port 8000..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'd:\chatbot\backend'; .\.venv\Scripts\Activate.ps1; uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload" -WindowStyle Normal

Start-Sleep -Seconds 5

# Start Frontend (Port 3000)
Write-Host "Starting Frontend on port 3000..." -ForegroundColor Cyan
Set-Location "d:\chatbot\frontend"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'd:\chatbot\frontend'; npm run dev" -WindowStyle Normal

Start-Sleep -Seconds 10

# Verify
Write-Host ""
Write-Host "=== Status Check ===" -ForegroundColor Cyan

# AI Agent
try {
    $c = Invoke-WebRequest -Uri "http://localhost:8001/health" -Method GET -TimeoutSec 5 -UseBasicParsing
    Write-Host "✓ AI Agent: ONLINE" -ForegroundColor Green
}
catch {
    Write-Host "✗ AI Agent: OFFLINE" -ForegroundColor Red
}

# Backend
try {
    $c = Invoke-WebRequest -Uri "http://localhost:8000/" -Method GET -TimeoutSec 5 -UseBasicParsing
    Write-Host "✓ Backend:  ONLINE" -ForegroundColor Green
}
catch {
    Write-Host "✗ Backend:  OFFLINE" -ForegroundColor Red
}

# Frontend
try {
    $c = Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -TimeoutSec 5 -UseBasicParsing
    Write-Host "✓ Frontend: ONLINE" -ForegroundColor Green
}
catch {
    Write-Host "✗ Frontend: OFFLINE" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Ready at http://localhost:3000" -ForegroundColor Green
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
