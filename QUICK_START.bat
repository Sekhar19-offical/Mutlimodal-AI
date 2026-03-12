@echo off
title 🚀 Multimodal AI Chatbot - QUICK START
setlocal
cd /d "%~dp0"

:: --- Configuration ---
set "BACKEND_DIR=backend"
set "FRONTEND_DIR=frontend"
set "VENV_PATH=backend\.venv\Scripts\activate.ps1"

echo ========================================================
echo        🚀 MULTIMODAL AI CHATBOT - ONE-CLICK START
echo ========================================================
echo.

:: 1. Force Clean Ports (8000, 8001, 3000)
echo [1/4] Cleaning industrial ports...
for %%p in (3000, 8000, 8001) do (
    for /f "tokens=5" %%a in ('netstat -aon ^| findstr :%%p ^| findstr LISTENING') do (
        taskkill /F /PID %%a /T >nul 2>&1
    )
)
echo ✓ Ports cleared.
echo.

:: 2. Start AI Agent Core (Port 8001)
echo [2/4] Initializing AI Intelligence Layer (Port 8001)...
start /min cmd /c "cd /d %BACKEND_DIR% && .venv\Scripts\python.exe hybrid_rag_backend.py"
timeout /t 3 >nul

:: 3. Start Main Backend Controller (Port 8000)
echo [3/4] Initializing Logic Controller (Port 8000)...
start /min cmd /c "cd /d %BACKEND_DIR% && .venv\Scripts\uvicorn.exe app.main:app --host 0.0.0.0 --port 8000"
timeout /t 5 >nul

:: 4. Start Frontend UI (Port 3000)
echo [4/4] Launching Premium Interface (Port 3000)...
start /min cmd /c "cd /d %FRONTEND_DIR% && npm run dev"

echo.
echo ========================================================
echo   ✨ SUCCESS: SYSTEM IS ONLINE
echo ========================================================
echo   - AI Core:   http://localhost:8001
echo   - Backend:   http://localhost:8000
echo   - Frontend:  http://localhost:3000
echo.
echo Launching browser in 3 seconds...
timeout /t 3 >nul
explorer "http://localhost:3000"

exit
