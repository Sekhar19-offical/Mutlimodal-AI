# Quick Health Check Script for Multimodal Chatbot

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Chatbot Health Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allHealthy = $true

# Check AI Agent Service (Port 8001)
Write-Host "Checking AI Agent Service (Port 8001)..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:8001/health" -UseBasicParsing -Method GET -TimeoutSec 3 -ErrorAction Stop
    Write-Host " OK" -ForegroundColor Green
}
catch {
    Write-Host " OFFLINE" -ForegroundColor Red
    $allHealthy = $false
}

# Check Main Backend (Port 8000)
Write-Host "Checking Main Backend (Port 8000)..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:8000/" -UseBasicParsing -Method GET -TimeoutSec 3 -ErrorAction Stop
    Write-Host " OK" -ForegroundColor Green
}
catch {
    Write-Host " OFFLINE" -ForegroundColor Red
    $allHealthy = $false
}

# Check Frontend (Port 3000)
Write-Host "Checking Frontend (Port 3000)..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:3000" -UseBasicParsing -Method GET -TimeoutSec 3 -ErrorAction Stop
    Write-Host " OK" -ForegroundColor Green
}
catch {
    Write-Host " OFFLINE" -ForegroundColor Red
    $allHealthy = $false
}

# Check Ollama (optional)
Write-Host "Checking Ollama (optional)..." -NoNewline
try {
    $ollamaResponse = Invoke-WebRequest -Uri "http://127.0.0.1:11434/api/tags" -UseBasicParsing -Method GET -TimeoutSec 2 -ErrorAction Stop
    Write-Host " OK" -ForegroundColor Green
}
catch {
    Write-Host " OFFLINE (optional)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

if ($allHealthy) {
    Write-Host "  Status: ALL SYSTEMS OPERATIONAL" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your chatbot is ready at: http://localhost:3000" -ForegroundColor Cyan
}
else {
    Write-Host "  Status: SOME SERVICES ARE DOWN" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To start all services, run:" -ForegroundColor Yellow
    Write-Host "  .\start-chatbot.ps1" -ForegroundColor White
}

Write-Host ""
