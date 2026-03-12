# Start-App.ps1 - Launcher for Multimodal Chatbot
Write-Host "Starting Multimodal Chatbot..." -ForegroundColor Cyan

# 1. Start Ollama (if not running)
$ollama = Get-Process ollama -ErrorAction SilentlyContinue
if (-not $ollama) {
    Write-Host "Starting Ollama..." -ForegroundColor Yellow
    Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 2
} else {
    Write-Host "Ollama is already running." -ForegroundColor Green
}


# 2. Start Backend (Controller - Port 8000)
Write-Host "Starting Backend Controller..." -ForegroundColor Yellow
$backendScript = "
cd '$PSScriptRoot\backend';
if (Test-Path 'venv\Scripts\Activate.ps1') { . 'venv\Scripts\Activate.ps1' } 
elseif (Test-Path '.venv\Scripts\Activate.ps1') { . '.venv\Scripts\Activate.ps1' };
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
"
Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendScript

# 3. Start Agent Service (AI Core - Port 8001)
Write-Host "Starting Agent Service..." -ForegroundColor Yellow
$agentScript = "
cd '$PSScriptRoot\backend';
if (Test-Path 'venv\Scripts\Activate.ps1') { . 'venv\Scripts\Activate.ps1' } 
elseif (Test-Path '.venv\Scripts\Activate.ps1') { . '.venv\Scripts\Activate.ps1' };
python hybrid_rag_backend.py
"
Start-Process powershell -ArgumentList "-NoExit", "-Command", $agentScript

# 4. Start Frontend
Write-Host "Starting Frontend..." -ForegroundColor Yellow
$frontendScript = "
cd '$PSScriptRoot\frontend';
npm run dev
"
Start-Process powershell -ArgumentList "-NoExit", "-Command", $frontendScript

Write-Host "All services started!" -ForegroundColor Green
Write-Host "Backend: http://127.0.0.1:8000"
Write-Host "Frontend: http://localhost:3000"
