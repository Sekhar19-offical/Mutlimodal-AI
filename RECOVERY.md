# 🆘 Connection Recovery Guide

If you see the error **"Sorry, I'm having trouble connecting to the server"**, follow these steps in order.

---

### Step 1: Run the Automatic Fixer (Easiest)
Open a terminal in the project root and run:
```powershell
.\fix-connection.ps1
```
*This script will clear blocked ports, check Ollama, and restart the backend.*

---

### Step 2: Manual Check (If Step 1 fails)

#### 1. Check if Ollama is running
Ollama must be active for the AI to respond.
- **Command:** `Get-Process -Name "ollama"`
- **If missing:** Open the Ollama app or run `ollama serve` in a new terminal.

#### 2. Kill ghost processes
Sometimes a "ghost" backend process stays alive and blocks the port.
- **Run this exact command:**
  ```powershell
  Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess | ForEach-Object { Stop-Process -Id $_ -Force }
  ```

#### 3. Start the Backend Manually
Open a terminal in the `backend` folder and run:
```powershell
.\start-backend.ps1
```
*Wait until you see "Application startup complete".*

---

### Step 3: Verify the Connection
Paste this into your terminal to see if the backend is "alive":
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/"
```
**Expected Output:** `status: Backend running`

---

### Step 4: Refresh Frontend
Go to your browser at `http://localhost:3000` and refresh (F5).
Look for the **🟢 BACKEND ONLINE** dot at the bottom left.

---

### 🔍 Still stuck?
Check the `backend` terminal for red error text. Common issues:
- **"ModuleNotFoundError"**: Run `pip install -r requirements.txt` in the backend folder.
- **"Port 8000 already in use"**: Repeat Step 2.2 above.
- **"Ollama connection refused"**: Ensure Ollama is running and you have the models (`ollama pull llama3.2`).
