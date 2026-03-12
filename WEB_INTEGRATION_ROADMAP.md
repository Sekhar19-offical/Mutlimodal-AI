# 🌐 Web Integration Roadmap (Phases 1-5)

This roadmap guides the transformation of Cortex into a fully web-connected, agentic system.

## PHASE 1: Web Search Integration ⏱️ Week 1
### 1.1 Core Dependencies Installation
- [ ] Install `duckduckgo-search` (primary search engine)
- [ ] Install `requests` (HTTP client)
- [ ] Install `beautifulsoup4` (HTML parsing)
- [ ] Install `lxml` (faster HTML parsing)
- [ ] Install `urllib3` (connection pooling)
- [ ] Test all packages work on free-tier (Render/Vercel compatibility)

### 1.2 Web Search Tool Development
- [ ] Create `tools/web_search.py` file
- [ ] Implement DuckDuckGo search wrapper
- [ ] Add result filtering (remove ads, duplicates)
- [ ] Add error handling for network failures
- [ ] Add timeout limits (5s max for free tier)
- [ ] Create tool schema for ReAct agent
- [ ] Test with 10 different query types
- [ ] Add result caching (Redis or in-memory)

### 1.3 Web Scraping Tool Development
- [ ] Create `tools/web_scraper.py` file
- [ ] Implement URL fetching with headers
- [ ] Add HTML to text conversion (BeautifulSoup)
- [ ] Remove scripts, styles, ads from content
- [ ] Implement smart truncation (5000 chars max)
- [ ] Add robots.txt compliance check
- [ ] Test with 20 different website types
- [ ] Handle JavaScript-rendered sites (optional: Playwright)

### 1.4 ReAct Loop Integration
- [ ] Update `agent/react_loop.py` to register new tools
- [ ] Add tool selection logic (when to search web vs use local)
- [ ] Create prompt templates for web-enhanced reasoning
- [ ] Implement tool result formatting
- [ ] Add iteration limits (max 5 web calls per query)
- [ ] Test ReAct loop with web tools
- [ ] Add logging for tool usage analytics

### 1.5 API Endpoint Updates
- [ ] Update `backend/routes/chat.py` for web-enabled chat
- [ ] Add `/chat/web` endpoint specifically for internet queries
- [ ] Implement request validation
- [ ] Add rate limiting (10 web searches/min per user)
- [ ] Return tool usage metadata to frontend
- [ ] Test API with Postman/curl

## PHASE 2: Specialized Web APIs
### 2.1 News API Integration
- [ ] Sign up for GNews API (free tier: 100 requests/day)
- [ ] Create `tools/news_api.py` file
- [ ] Implement news search by topic
- [ ] Add news search by date range
- [ ] Add source credibility filtering
- [ ] Cache news results (1 hour TTL)
- [ ] Test with current events

### 2.2 Weather API Integration
- [ ] Sign up for OpenWeatherMap (free tier: 1000 calls/day)
- [ ] Create `tools/weather_api.py` file
- [ ] Implement current weather lookup
- [ ] Add 5-day forecast capability
- [ ] Support city name and coordinates
- [ ] Handle API errors gracefully
- [ ] Test with 50 different cities

### 2.3 Wikipedia/Knowledge Graph
- [ ] Install `wikipedia` Python library
- [ ] Create `tools/wikipedia_api.py` file
- [ ] Implement search and summary extraction
- [ ] Handle disambiguation pages
- [ ] Add category extraction
- [ ] Link to related topics
- [ ] Test with 30 different topics

### 2.4 Real-Time Data APIs
- [ ] Stock Prices: Alpha Vantage API (free tier)
- [ ] Cryptocurrency: CoinGecko API (free, unlimited)
- [ ] Exchange Rates: Exchangerate API (free tier)
- [ ] Create unified `tools/realtime_data.py` file
- [ ] Implement caching (5min for stocks, 1min for crypto)
- [ ] Test all data sources

## PHASE 3: Intelligent Tool Selection
### 3.1 Query Classification System
- [ ] Create `agent/query_classifier.py` file
- [ ] Build keyword-based classifier
- [ ] Add intent detection (search vs calculate vs factual)
- [ ] Implement recency detection (current, latest, today)
- [ ] Train simple ML classifier (optional: scikit-learn)
- [ ] Test with 100 different query types

### 3.2 Decision Engine
- [ ] Create tool selection logic flowchart
- [ ] Implement decision tree for tool selection
- [ ] Add confidence scoring for each tool
- [ ] Implement fallback chain (web → local → error)
- [ ] Add A/B testing framework
- [ ] Log decision metrics

### 3.3 Hybrid Search Strategy
- [ ] Implement parallel search (web + local RAG)
- [ ] Create result fusion algorithm
- [ ] Add source credibility scoring
- [ ] Implement answer synthesis from multiple sources
- [ ] Test accuracy vs speed tradeoffs

### 3.4 Prompt Engineering
- [ ] Create system prompts for web-augmented reasoning
- [ ] Add few-shot examples for tool use
- [ ] Implement chain-of-thought prompting
- [ ] Test prompts with Ollama and Gemini
- [ ] Optimize token usage (<2000 tokens per request)

## PHASE 4: Performance Optimization
### 4.1 Caching Layer
- [ ] Install Redis or use Upstash (free tier)
- [ ] Implement search result caching (1 hour TTL)
- [ ] Add embedding cache for RAG queries
- [ ] Cache API responses (weather: 10min, news: 30min)
- [ ] Implement cache invalidation logic
- [ ] Monitor cache hit rate (target >60%)

### 4.2 Request Optimization
- [ ] Implement connection pooling for HTTP requests
- [ ] Add request batching for multiple searches
- [ ] Use HTTP/2 for faster connections
- [ ] Implement request deduplication
- [ ] Add smart timeouts (3s search, 5s scrape)
- [ ] Test under load (100 concurrent requests)

### 4.3 Response Streaming
- [ ] Implement Server-Sent Events (SSE) for chat
- [ ] Stream search results as they arrive
- [ ] Add progressive loading in frontend
- [ ] Test streaming with slow connections
- [ ] Optimize for mobile networks

### 4.4 Error Handling & Resilience
- [ ] Implement retry logic (3 attempts with exponential backoff)
- [ ] Add circuit breaker pattern for failing APIs
- [ ] Create fallback chains (primary → backup → cached)
- [ ] Log all errors to monitoring service
- [ ] Test failure scenarios (API down, timeout, rate limit)

## PHASE 5: Free-Tier Deployment
### 5.1 Environment Configuration
- [ ] Create `.env.example` with all API keys
- [ ] Document free tier limits for each service
- [ ] Set up environment variables in Render/Vercel
- [ ] Create deployment checklist
- [ ] Test all services in production environment

### 5.2 Rate Limiting & Cost Control
- [ ] Implement per-user rate limits
- [ ] Add daily quota tracking
- [ ] Create usage dashboard
- [ ] Set up alerts for quota exhaustion
- [ ] Implement graceful degradation (disable web if quota hit)

### 5.3 Monitoring & Analytics
- [ ] Set up Sentry for error tracking
- [ ] Add custom metrics (tool usage, latency)
- [ ] Create health check endpoints
- [ ] Monitor API response times
- [ ] Track cache hit rates
- [ ] Set up uptime monitoring (UptimeRobot free)

### 5.4 Documentation
- [ ] Document all API endpoints
- [ ] Create tool usage guide
- [ ] Write deployment guide
- [ ] Document free tier limits
- [ ] Create troubleshooting guide
