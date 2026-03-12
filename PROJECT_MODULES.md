# Cortex: Project Module Specification

This document provides a detailed breakdown of the functional modules within the **Cortex Multimodal AI Chatbot** project. This modular architecture ensures scalability, maintainability, and efficient resource utilization.

---

## 1. User Interface (Frontend) Module
**Core Technologies:** Next.js 14, Tailwind CSS, TypeScript, PDF.js
- **Chat Interface Module**: Implements a high-fidelity, responsive chat window with support for real-time message streaming using Server-Sent Events (SSE).
- **Client-Side Processing Module**: Utilizes `pdfjs-dist` to extract text from PDF documents directly in the browser, reducing server load and improving privacy.
- **Authentication UI Module**: Managed pages for User Registration, Login, and Password Recovery with OTP-based verification simulations.
- **Media Handling Module**: Supports drag-and-drop file uploads and real-time image previews for multimodal queries.

---

## 2. API Gateway & Controller (Backend) Module
**Core Technologies:** FastAPI, SQLAlchemy, JWT, bcrypt
- **Security & Auth Module**: Handles JSON Web Token (JWT) generation, password hashing (bcrypt), and secure session management.
- **Rate-Limiter Module (SlowAPI)**: Protects endpoints from abuse by limiting requests for login (5/min), signup (3/min), and chat (20/min).
- **Request Router Module**: Acts as the "Body," validating incoming requests via Pydantic schemas and directing them to the appropriate AI services.
- **Database Abstractor Module**: Interfaces with SQLite (local) or PostgreSQL (production) for persistent storage of user history and configuration.

---

## 3. AI Agent Core (Reasoning) Module
**Core Technologies:** Python, LangChain, ReAct Framework
- **Query Classification Module**: Analyzes user intent to decide if a query needs simple LLM generation, deep RAG retrieval, or real-time internet search.
- **ReAct Execution Engine**: Implements the **Reason + Act** loop, allowing the agent to perform multi-step planning and tool execution to solve complex problems.
- **Context & Memory Module**: Manages short-term conversation memory to maintain coherent dialogue over multiple turns.
- **Self-Learning Analytics Module**: Tracks agent performance and tool success rates to provide optimization "hints" for future queries.

---

## 4. Multimodal & RAG Processing Module
**Core Technologies:** Gemini Vision API, Whisper STT, FAISS, Sentence Transformers
- **Vision Recognition Module**: Integrates Google’s Gemini 2.0 Flash to "see" and describe uploaded images or extract text from visual data.
- **Voice Intelligence Module**: Implements Speech-to-Text (Whisper) and Text-to-Speech (pyttsx3) for hands-free interaction.
- **Hybrid RAG Pipeline**:
    - **Vectorization Module**: Encodes document chunks into 384-dimensional embeddings using the MiniLM-L6 model.
    - **FAISS Search Module**: Performs high-speed similarity searches for semantic retrieval from the knowledge base.

---

## 5. External Tools & Integration Module
**Core Technologies:** BeautifulSoup4, DuckDuckGo API, Yahoo Finance
- **Web Search Module**: A 5-layer fallback system (DDG, Google, HTML Scrapers) to ensure the agent always finds up-to-date internet data.
- **Financial Intelligence Module**: Real-time integration with Yahoo Finance for stock prices, crypto trends, and currency exchange rates.
- **Environmental Data Module**: Connects to Open-Meteo API for real-time weather and forecasting.
- **Information Scraper Module**: Dynamically extracts clean content from any provided URL for deep analysis.
