
# 🧠 Cortex - Scalable Multimodal AI Agent

**Cortex** is a production-ready, agentic AI chatbot designed for real-world deployment. Unlike simple wrappers, Cortex features a **Microservices Architecture** that separates the "Body" (API Controller) from the "Brain" (AI Agent), allowing it to scale from a free tier prototype to a massive enterprise application.

---

## � Key Features

### 🤖 Agentic Intelligence
- **ReAct Loop**: Cortex doesn't just answer; it *thinks*. It uses a Reason -> Act -> Observe loop to solve complex problems.
- **Tools**: Equipped with **Web Search** (Live Internet Access), **Calculator**, and **RAG Search**.
- **Memory**: Remembers conversation context across sessions (Redis-ready).

### 👁️ Multimodal Capabilities
- **Vision**: Upload images (PNG, JPG) and Cortex can see, analyze, and answer questions about them using **Gemini Vision** or **LLaVA**.
- **Documents**: Drag & Drop PDFs/DOCX. The **Frontend** extracts text locally (privacy-first & fast), and the Agent performs **RAG (Retrieval Augmented Generation)** to answer questions based on the document.
- **Voice**: Experimental support for Text-to-Speech (TTS) and Speech-to-Text (STT) for hands-free interaction.

### ⚡ Optimized Performance (Free Tier Ready)
- **Lazy Loading**: AI models only load when needed, reducing startup RAM to <500MB.
- **Client-Side Extraction**: Heavy PDF processing is offloaded to the user's browser, saving server resources.
- **Health Checks**: Built-in endpoints to keep free-tier servers (Render/Vercel) awake.

---

## 🏗️ Architecture

Cortex uses a split-stack architecture for maximum scalability:

```mermaid
graph TD
    Client[🖥️ Frontend (Next.js)] -- HTTP/JSON --> Controller[🛡️ Backend Controller (Port 8000)]
    Controller -- Internal API --> Agent[🧠 AI Agent Service (Port 8001)]
    
    subgraph "Core Services"
        Controller
        Agent
    end
    
    Agent -- Search Request --> Web[🌐 Internet/DuckDuckGo]
    Agent -- Vector Search --> FAISS[📚 FAISS Knowledge Base]
    Agent -- API Call --> LLM[☁️ Gemini / Ollama]
```

### 1. Frontend (Port 3000)
- **Tech**: Next.js 14, React, Tailwind CSS, Lucide Icons.
- **Role**: UI, Client-side PDF processing, Chat interface.

### 2. Backend Controller (Port 8000)
- **Tech**: FastAPI, SQLAlchemy, PostgreSQL (Ready).
- **Role**: Authentication (JWT), Rate Limiting, Request Routing, File Upload Managment.

### 3. AI Agent Service (Port 8001)
- **Tech**: FastAPI, LangChain Concepts, FAISS.
- **Role**:The "Brain". Handles the ReAct loop, Tool execution, and Vector Search.

---

## 🚀 Quick Start (One-Tap Launch)

To start the entire system (Frontend, Backend, AI Agent) with a single action:

1.  **Double-click** the `LAUNCH_CHATBOT.bat` file in the project root.
2.  **Wait** for the windows to initialize.
3.  **Automatic:** Your browser will open to `http://localhost:3000` once the system is ready.

### Manual Start (Alternative)
If you prefer manual control:
1. **Backend**: `cd backend && .\venv\Scripts\activate && python start_system.py`
2. **Frontend**: `cd frontend && npm run dev`


---

## 🌍 Deployment

Cortex is optimized for **Free Tier** deployment:
- **Frontend**: Deploy to **Vercel**.
- **Backend**: Deploy to **Render** (as a Docker Web Service).

See [FREE_STACK_GUIDE.md](./FREE_STACK_GUIDE.md) and [DEPLOYMENT.md](./DEPLOYMENT.md) for step-by-step instructions.

---

## 📚 Documentation
- [PROJECT_STATUS.md](./PROJECT_STATUS.md) - Current development stage.
- [RAG_PIPELINE.md](./RAG_PIPELINE.md) - How the document search works.
- [SCALABILITY.md](./SCALABILITY.md) - How to scale to millions of users.
- [PUBLIC_ACCESS.md](./PUBLIC_ACCESS.md) - How to access locally via Tunnels.
