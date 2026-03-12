# Internet Connectivity Troubleshooting Guide

## Problem: "Internet has not connected and didn't get answers when user wants to raise questions"

### Root Cause
The chatbot uses a **microservices architecture** with two backend services that must both be running:
1. **Main Backend (Port 8000)** - Handles authentication and request forwarding
2. **AI Agent Service (Port 8001)** - Handles AI processing, web search, and tool execution

When either service is not running, users cannot get answers to their questions.

---

## Quick Fix - Start All Services

### Option 1: Use the Automated Startup Script (RECOMMENDED)
```powershell
cd d:\chatbot
.\start-chatbot.ps1
```

This script will:
- Check all dependencies (Python, Node.js, Ollama)
- Pull required Ollama models if missing
- Start all three services (AI Agent, Main Backend, Frontend)
- Verify that everything is running correctly

### Option 2: Run via Frontend (Developer Mode)
If you prefer using `npm`, we have configured a concurrent runner:
```powershell
cd d:\chatbot\frontend
npm run dev
```
This will start **BOTH** the Frontend and the Backend simultaneously in the same terminal window.


### Option 2: Manual Startup

#### Step 1: Start AI Agent Service (Port 8001)
```powershell
cd d:\chatbot\backend
.\.venv\Scripts\Activate.ps1
python hybrid_rag_backend.py
```

#### Step 2: Start Main Backend (Port 8000)
Open a new terminal:
```powershell
cd d:\chatbot\backend
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

#### Step 3: Start Frontend (Port 3000)
Open a new terminal:
```powershell
cd d:\chatbot\frontend
npm run dev
```

---

## Verify Services Are Running

### Check Service Status
```powershell
# Check if services are listening on their ports
netstat -ano | findstr "8000 8001 3000"
```

You should see:
- Port 8000 (Main Backend)
- Port 8001 (AI Agent)
- Port 3000 (Frontend)

### Test Endpoints Manually

#### Test AI Agent Service
```powershell
Invoke-WebRequest -Uri "http://localhost:8001/health" -Method GET
```
Expected response: `{"status":"ok","service":"Cortex Agent"}`

#### Test Main Backend
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/" -Method GET
```
Expected response: `{"status":"Multimodal Backend Online"}`

#### Test Frontend
Open browser: `http://localhost:3000`

---

## Common Issues and Solutions

### Issue 1: "Port already in use"
**Symptoms:** Error message like "Address already in use" or "Port 8000/8001 is already allocated"

**Solution:**
```powershell
# Find and kill processes using the ports
Get-Process -Id (Get-NetTCPConnection -LocalPort 8000).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -LocalPort 8001).OwningProcess | Stop-Process -Force
Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess | Stop-Process -Force
```

### Issue 2: "Module not found" or Import Errors
**Symptoms:** Python errors about missing modules

**Solution:**
```powershell
cd d:\chatbot\backend
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt --upgrade
```

### Issue 3: Web Search Not Working
**Symptoms:** Chatbot responds but doesn't provide internet-based answers

**Possible Causes:**
1. **AI Agent Service not running** - The web search tool is in the AI Agent
2. **Network connectivity issues** - Check your internet connection
3. **API rate limits** - DuckDuckGo or other search APIs may have rate limits

**Solution:**
1. Verify AI Agent is running: `Invoke-WebRequest -Uri "http://localhost:8001/health"`
2. Check backend logs: `Get-Content d:\chatbot\backend\system.log -Tail 50`
3. Test web search directly:
   ```powershell
   cd d:\chatbot\backend
   .\.venv\Scripts\Activate.ps1
   python -c "from app.tools.web_search import web_search; print(web_search('test query'))"
   ```

### Issue 4: "Failed to contact AI Service"
**Symptoms:** Error message in chat: "Failed to contact AI Service (Is it running on 8001?)"

**Solution:**
The Main Backend (8000) cannot reach the AI Agent (8001). Ensure:
1. AI Agent Service is running on port 8001
2. No firewall is blocking localhost connections
3. Check the `AI_AGENT_URL` environment variable in `.env`

### Issue 5: Gemini API Errors
**Symptoms:** "Rate limit hit" or "API key invalid"

**Solution:**
1. Check your Gemini API key in `d:\chatbot\backend\.env`:
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```
2. Verify API key at: https://makersuite.google.com/app/apikey
3. Check rate limits - free tier has limits on requests per minute

### Issue 6: Ollama Not Available
**Symptoms:** "Ollama unreachable" warning

**Note:** This is optional. The chatbot will use Gemini if Ollama is not available.

**To use Ollama (optional):**
1. Install Ollama from: https://ollama.ai
2. Start Ollama service
3. Pull a model: `ollama pull llama2`

---

## Architecture Overview

```
User Browser (Port 3000)
    ↓
Frontend (Next.js)
    ↓
Main Backend (Port 8000) - Authentication, Request Routing
    ↓
AI Agent Service (Port 8001) - AI Processing, Web Search, RAG
    ↓
External Services:
    - DuckDuckGo (Web Search)
    - Google (Fallback Search)
    - Wikipedia API
    - Weather API (Open-Meteo)
    - Stock Data (Yahoo Finance)
    - Gemini AI (Google)
    - Ollama (Local LLM - Optional)
```

---

## Environment Variables

### Backend (.env)
Located at: `d:\chatbot\backend\.env`

Required variables:
```env
SECRET_KEY=your_secret_key_here
BACKEND_CORS_ORIGINS=http://localhost:3000
GEMINI_API_KEY=your_gemini_api_key_here
```

Optional variables:
```env
AI_AGENT_URL=http://localhost:8001/agent/chat
AI_AGENT_UPLOAD_URL=http://localhost:8001/upload/doc
```

### Frontend (.env.local)
Located at: `d:\chatbot\frontend/.env.local`

```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

---

## Logs and Debugging

### View Backend Logs
```powershell
# Main backend log
Get-Content d:\chatbot\backend\backend_log.txt -Tail 50 -Wait

# AI Agent log
Get-Content d:\chatbot\backend\system.log -Tail 50 -Wait
```

### Enable Debug Mode
Edit `d:\chatbot\backend\app\agent_system\core.py` and change:
```python
logging.basicConfig(level=logging.DEBUG)  # Change from INFO to DEBUG
```

---

## Performance Tips

1. **Use Gemini for faster responses** - Gemini Cloud is faster than local Ollama
2. **Clear cache periodically** - Delete `d:\chatbot\backend\cache` folder
3. **Restart services daily** - Prevents memory leaks
4. **Monitor resource usage** - Check Task Manager for high CPU/RAM usage

---

## Getting Help

If issues persist:
1. Check all logs for error messages
2. Verify all dependencies are installed
3. Ensure API keys are valid
4. Test each service independently
5. Check firewall/antivirus settings

---

## Quick Health Check Script

```powershell
# Save this as check-health.ps1
Write-Host "Checking Chatbot Health..." -ForegroundColor Cyan

$services = @(
    @{Name="AI Agent"; URL="http://localhost:8001/health"},
    @{Name="Main Backend"; URL="http://localhost:8000/"},
    @{Name="Frontend"; URL="http://localhost:3000"}
)

foreach ($service in $services) {
    try {
        $response = Invoke-WebRequest -Uri $service.URL -Method GET -TimeoutSec 3
        Write-Host "✓ $($service.Name): ONLINE" -ForegroundColor Green
    } catch {
        Write-Host "✗ $($service.Name): OFFLINE" -ForegroundColor Red
    }
}
```

Run with: `.\check-health.ps1`
