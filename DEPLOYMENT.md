
# Deployment Guide: Multimodal AI Chatbot

This guide outlines the steps to deploy your 3-tier application (Frontend, Backend Controller, AI Agent) from Developer Mode (Locahost) to Production.

## 1. Environment Preparation

### Backend (.env.production)
Create a production environment file `backend/.env.production` on your server:
```ini
# Security
SECRET_KEY=generate_a_secure_random_string_here
ACCESS_TOKEN_EXPIRE_MINUTES=1440

# AI Keys
GEMINI_API_KEY=your_gemini_api_key_here
OPENAI_API_KEY=your_openai_key_if_used

# Database
# Use a production DB (PostgreSQL) instead of SQLite if possible
DATABASE_URL=postgresql://user:password@localhost/dbname

# CORS
# Comma-separated list of allowed origins (your frontend domain)
BACKEND_CORS_ORIGINS=https://your-frontend-domain.com
```

### Frontend (.env.production)
Create `frontend/.env.production` for build time:
```ini
# Controller API URL (Public URL of your Backend Controller)
NEXT_PUBLIC_API_URL=https://api.your-domain.com
```

---

## 2. Deploying the AI Intelligence Layer (Port 8001)

The AI Layer is computationally heavy and should run on a **VPS** or **Container Service** (e.g., AWS EC2, Google Compute Engine, or DigitalOcean Droplet).

**Steps:**
1. **Clone Repo**: Pull your code to the server.
2. **Install Deps**: `pip install -r backend/requirements.txt`
3. **Run with Gunicorn (Production Server)**:
   Do not use `uvicorn main:app --reload`. Use a process manager like Gunicorn with Uvicorn workers.

   ```bash
   cd backend
   # Run AI Agent on Port 8001
   gunicorn -w 4 -k uvicorn.workers.UvicornWorker hybrid_rag_backend:app --bind 0.0.0.0:8001 --daemon
   ```
   *Note: For GPU support (local models), ensure CUDA is installed.*

---

## 3. Deploying the Backend Controller (Port 8000)

This layer is lightweight (auth, logic) and can run on the **same server** or a **Serverless Platform** (e.g., AWS Lambda, Google Cloud Run, Railway).

**Steps:**
1. **Update Agent URL**: In `backend/app/main.py`, change `AGENT_URL` from `localhost` to the internal IP or private URL of your AI Service if they are on different machines.
   ```python
   # backend/app/main.py
   AGENT_URL = os.getenv("AI_AGENT_URL", "http://localhost:8001/agent/chat")
   ```
2. **Run with Gunicorn**:
   ```bash
   cd backend
   # Run Controller on Port 8000
   gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:8000 --daemon
   ```

---

## 4. Deploying the Frontend (Next.js)

Deploy to a specialized frontend host like **Vercel** (recommended for Next.js) or **Netlify**.

**Steps:**
1. **Push to GitHub**: Ensure your code is in a repo.
2. **Connect to Vercel**: Import the project.
3. **Configure Settings**:
   - **Root Directory**: `frontend`
   - **Environment Variables**: Add `NEXT_PUBLIC_API_URL` pointing to your Backend Controller (e.g., `https://api.your-backend.com`).
4. **Deploy**: Vercel handles the build and global CDN distribution.

---

## 5. Nginx Reverse Proxy (Recommended for VPS)

If hosting Backend and AI on a VPS, use Nginx to map domains to ports and handle SSL (HTTPS).

**/etc/nginx/sites-available/myapp**
```nginx
server {
    listen 80;
    server_name api.your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:8000; # Forward to Controller
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```
*Secure it with Certbot (Let's Encrypt).*

---

## Summary of Architecture

| User | -> | Frontend (Vercel) | -> | Backend Controller (VPS Port 8000) | -> | AI Agent (VPS Port 8001) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Browser** | | **Static/Edge** | | **Auth & Routing** | | **Intelligence & Tools** |

This setup ensures scalability. You can scale the **AI Agent** vertically (bigger GPU server) without touching the Controller or Frontend.
