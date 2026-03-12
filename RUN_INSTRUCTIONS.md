# How to Run the Multimodal Chatbot

## Prerequisites
1. **Ollama**: Must be installed and running.
   - Download from: https://ollama.com/
   - Run command: `ollama serve`
   - Pull models: `ollama pull llama3.2` and `ollama pull llava`

## Option 1: The Easy Way (Recommended)
We have created a startup script that handles everything for you (checks Ollama, starts backend, starts frontend).

1. Open PowerShell in the project root (`d:\multimodal_chatbot`).
2. Run:
   ```powershell
   .\start-dev.ps1
   ```

## Option 2: Manual Start (Step-by-Step)

If you prefer to run things manually, you need **three** separate terminals.

### Terminal 1: Ollama (AI Engine)
```powershell
ollama serve
```

### Terminal 2: Backend (Python API)
```powershell
cd backend
# Activate Virtual Environment
.\venv\Scripts\Activate.ps1
# Start Server
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```
*Wait until you see "Application startup complete".*

### Terminal 3: Frontend (Web Interface)
```powershell
cd frontend
npm run dev
```
*Open http://localhost:3000 in your browser.*

## Troubleshooting
- **Backend Offline?**: Make sure Terminal 2 is running and shows no errors.
- **AI Engine Offline?**: Make sure Terminal 1 (Ollama) is running.
- **Connection Refused?**: Ensure nothing else is using port 8000 or 3000.
