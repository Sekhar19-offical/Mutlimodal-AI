
# RAG Pipeline Architecture & Optimizations

The Retrieval-Augmented Generation (RAG) pipeline has been re-architected for **Efficiency** and **Scalability**.

## 1. The Strategy: "Long-Context" vs. "Vector Store"

We now use a **Hybrid Approach** to handle documents, optimizing for both speed and long-term memory.

### A. Instant Context (The "Fast Path")
**Best for:** Uploading a PDF/Doc and asking questions immediately.
1.  **Client-Side Extraction**: Upon upload, the **Browser** (Frontend) extracts text using `pdfjs-dist`.
2.  **Prompt Injection**: This text is sent directly to the AI Agent as part of the prompt.
3.  **Result**: 
    *   **Zero Server RAM Spike**: The backend doesn't have to load heavy PDF parsers.
    *   **Instant Availability**: No waiting for "Indexing" or "Embedding".
    *   **High Accuracy**: The model sees the *exact* text in its context window.

### B. Knowledge Base (The "Deep Path")
**Best for:** Storing massive documentation for future recall.
1.  **Ingestion**: Files sent to `/upload/doc` are processed by the **Agent Service** (Port 8001).
2.  **Lazy Vectorization**: 
    *   The Embedding Model (`all-MiniLM-L6-v2`) is **Lazy Loaded** (only loads on first write/read).
    *   This keeps the server lightweight during startup.
3.  **Storage**: Text chunks are stored in a FAISS Vector Index (Disk-backed).
4.  **Retrieval**: The Agent autonomously calls the `[rag_search]` tool when users ask about stored knowledge.

## 2. Key Optimizations

| Feature | Old Architecture | New Scalable Architecture |
| :--- | :--- | :--- |
| **PDF Parsing** | Backend (PyPDF2) - Slow, Heavy | **Frontend (PDF.js)** - Distributed, Fast |
| **Model Loading** | On Startup (Blocks Boot) | **Lazy (On Demand)** - Faster Boot |
| **Memory Usage** | Double Loaded (Controller + Agent) | **Single Instance** (Agent Only) |
| **Model Size** | Large (Default) | **Optimized (MiniLM-L6)** - 5x Smaller |

## 3. Current Status
- **Active Pipeline**: The "Fast Path" is active in the Chat Interface.
- **Background Pipeline**: The Vector Store is ready and optimized but currently secondary to the direct context injection.
