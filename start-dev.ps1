# Multimodal Chatbot Development Startup Script
# This script starts both backend and frontend servers

Write-Host "Starting Multimodal Chatbot Development Environment..." -ForegroundColor Cyan

# Check if Ollama is running
Write-Host "Checking Ollama status..." -ForegroundColor Yellow
$ollamaProcess = Get-Process -Name "ollama" -ErrorAction SilentlyContinue
if (-not $ollamaProcess) {
    Write-Host "Ollama is not running!" -ForegroundColor Red
    Write-Host "Please start Ollama first (ollama serve)." -ForegroundColor Yellow
    exit 1
}
Write-Host "Ollama is running" -ForegroundColor Green

# Start backend server in a new window
Write-Host "Starting FastAPI backend server (Port 8000)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-File", "$PSScriptRoot\backend\start-backend.ps1"

# Start Agent Service in a new window
Write-Host "Starting Agent Service (Port 8001)..." -ForegroundColor Yellow
$agentCmd = "
cd '$PSScriptRoot\backend';
if (Test-Path 'venv\Scripts\Activate.ps1') { . 'venv\Scripts\Activate.ps1' } 
elseif (Test-Path '.venv\Scripts\Activate.ps1') { . '.venv\Scripts\Activate.ps1' };
python hybrid_rag_backend.py
"
Start-Process powershell -ArgumentList "-NoExit", "-Command", $agentCmd


# Wait for backend to start
Write-Host "Waiting for backend to initialize..." -ForegroundColor Yellow
$maxRetries = 15
$retryCount = 0
$backendReady = $false

while ($retryCount -lt $maxRetries -and -not $backendReady) {
    try {
        $response = Invoke-WebRequest -Uri "http://127.0.0.1:8000/" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            $backendReady = $true
            Write-Host "Backend is healthy and ready!" -ForegroundColor Green
        }
    } catch {
        $retryCount++
        Start-Sleep -Seconds 2
    }
}

if (-not $backendReady) {
    Write-Host "Backend failed to start or is taking too long." -ForegroundColor Red
    Write-Host "Please check the new PowerShell window for errors." -ForegroundColor Yellow
}

# Start frontend server
Write-Host "Starting Next.js frontend server..." -ForegroundColor Yellow
Set-Location "$PSScriptRoot\frontend"
npm run dev
