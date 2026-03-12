# ONE_TAP_START.ps1 - The Ultimate Launcher for Cortex Chatbot
# Version: 2.3 (Lint Fixed)

$project_root = Get-Location
Write-Host "Starting Cortex AI Stack..." -ForegroundColor Cyan

# Cleanup
Get-NetTCPConnection -LocalPort 3000, 8000, 8001 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess | ForEach-Object { 
    $proc_id = $_
    Stop-Process -Id $proc_id -Force -ErrorAction SilentlyContinue 
}

# Ollama
if (-not (Get-Process ollama -ErrorAction SilentlyContinue)) {
    Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 2
}

# Microservices
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$project_root\backend'; .\.venv\Scripts\Activate.ps1; python hybrid_rag_backend.py"
Start-Sleep -Seconds 2
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$project_root\backend'; .\.venv\Scripts\Activate.ps1; uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"
Start-Sleep -Seconds 2
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$project_root\frontend'; npm run dev"

# Launch Browser
Write-Host "Warming up systems..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Start-Process "http://localhost:3000"

Write-Host "System is powering up. Check the new windows for status." -ForegroundColor Green
Write-Host "Chatbot will open in your browser shortly."
Start-Sleep -Seconds 5
