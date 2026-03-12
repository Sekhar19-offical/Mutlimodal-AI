# Headless Startup Script for Multimodal Chatbot

$logDir = "d:\chatbot\logs"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }

Write-Host "Starting services in headless mode..." -ForegroundColor Cyan

# 1. Start Agent Service (Port 8001)
Write-Host "Starting Agent Service on port 8001..." -ForegroundColor Yellow
$agentCmd = "cd 'd:\chatbot\backend'; .\.venv\Scripts\Activate.ps1; python hybrid_rag_backend.py"
Start-Process powershell -ArgumentList "-Command", "$agentCmd" -RedirectStandardOutput "$logDir\agent.log" -RedirectStandardError "$logDir\agent_error.log" -NoNewWindow -PassThru

# 2. Start Main Backend (Port 8000)
Write-Host "Starting Main Backend on port 8000..." -ForegroundColor Yellow
$backendCmd = "cd 'd:\chatbot\backend'; .\.venv\Scripts\Activate.ps1; uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload"
Start-Process powershell -ArgumentList "-Command", "$backendCmd" -RedirectStandardOutput "$logDir\backend.log" -RedirectStandardError "$logDir\backend_error.log" -NoNewWindow -PassThru

# 3. Start Frontend (Port 3000)
Write-Host "Starting Frontend on port 3000..." -ForegroundColor Yellow
$frontendCmd = "cd 'd:\chatbot\frontend'; npm run dev"
Start-Process powershell -ArgumentList "-Command", "$frontendCmd" -RedirectStandardOutput "$logDir\frontend.log" -RedirectStandardError "$logDir\frontend_error.log" -NoNewWindow -PassThru

Write-Host "Services started. Waiting 10 seconds for initialization..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

# Verify services
Write-Host "Verifying services..." -ForegroundColor Cyan

# Check Agent
try {
    $agentCheck = Invoke-WebRequest -Uri "http://localhost:8001/health" -Method GET -TimeoutSec 2
    Write-Host "[OK] Agent Service (8001)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Agent Service (8001)" -ForegroundColor Red
    Write-Host "Check logs at $logDir\agent_error.log" -ForegroundColor Red
}

# Check Backend
try {
    $backendCheck = Invoke-WebRequest -Uri "http://localhost:8000/" -Method GET -TimeoutSec 2
    Write-Host "[OK] Main Backend (8000)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Main Backend (8000)" -ForegroundColor Red
    Write-Host "Check logs at $logDir\backend_error.log" -ForegroundColor Red
}

# Check Frontend
try {
    $frontendCheck = Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -TimeoutSec 2
    Write-Host "[OK] Frontend (3000)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Frontend (3000)" -ForegroundColor Red
    Write-Host "Check logs at $logDir\frontend_error.log" -ForegroundColor Red
}
