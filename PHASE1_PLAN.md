
# IMPLEMENTATION PLAN: Phase 1 - Immediate Optimization for Free Tier

This plan outlines the specific steps to execute the user's optimization request.

## Goal
Optimize the application to run within the constraints of free hosting tiers (Render/Vercel) by reducing memory usage and handling cold starts.

## Strategy
1.  **Frontend Offloading**: Move PDF processing to the client to save backend RAM.
2.  **Backend Efficiency**: Implement lazy loading for the AI model and switch to a lighter model.
3.  **Keep-Alive**: Implement a system to prevent cold starts.
4.  **Vector Optimization**: Reduce the memory footprint of the FAISS index.

## Execution Steps

### Task 1.1: Frontend PDF Processing (Client-Side Extraction)
- [ ] **Install `pdfjs-dist`** in the frontend: `npm install pdfjs-dist`
- [ ] **Create Utility**: `frontend/lib/pdfUtils.ts` to extract text from PDF files in the browser.
- [ ] **Update Upload Component**: Modify `ChatInterface.tsx` (or relevant component) to parse the PDF *before* sending.
- [ ] **Update Backend API**: Change `/upload/doc` endpoint to accept **raw text** instead of a file.
- [ ] **Cleanup**: Remove `pypdf` from backend `requirements.txt` and `hybrid_rag_backend.py`.

### Task 1.2: Backend Lazy Loading & Lighter Model
- [ ] **Update `requirements.txt`**: Ensure `sentence-transformers` is present.
- [ ] **Modify `hybrid_rag_backend.py`**:
    - Remove global model initialization.
    - Create a `get_embedding_model()` function with `@lru_cache` or a singleton pattern.
    - Initialize the model *inside* the function, only when first needed.
    - **Switch Model**: Explicitly load `all-MiniLM-L6-v2` (or `paraphrase-MiniLM-L3-v2` as requested if available/better for size). *Note: `all-MiniLM-L6-v2` is the standard "small" fast model.*

### Task 1.3: Cold Start Prevention (Keep-Alive)
- [ ] **Verify Health Endpoint**: Ensure `/` or `/health` endpoint exists in `hybrid_rag_backend.py` and returns a 200 OK quickly.
- [ ] **Documentation**: Add a section to `DEPLOYMENT.md` explaining how to set up `cron-job.org` to ping this endpoint every 10 minutes.

### Task 1.4: Memory Optimization (FAISS & Chunking)
- [ ] **Modify Vector Store**: In `app/memory/vector.py` (or wherever Faiss is initialized):
    - Ensure the index is created with the correct dimension for the new model (384 for MiniLM).
    - *Note: Reducing dimensions from 384 to 256 might require a specific model or dimensionality reduction, which adds complexity. We will stick to the 384-dim Small model first as it's standard and very light.*
- [ ] **Chunking Logic**: Update the text ingestion to strictly limit text chunks to 500 characters/tokens.
- [ ] **Monitoring**: Add a `/stats` endpoint to report current RAM usage (using `psutil`).

## Order of Operations
1.  **Backend Model Optimization (1.2 & 1.4)**: This has the biggest impact on startup memory.
2.  **Frontend PDF Loading (1.1)**: Removes the need for heavy PDF libraries on the server.
3.  **Deployment Prep (1.3)**: Finalize health checks and documentation.

Let's begin with **Step 1: Backend Model Optimization**.
