
# How to Make Your App Public (Remove Localhost)

You have successfully refactored the application to use Environment Variables. This means "Localhost" is no longer hardcoded in the critical paths.

## Option 1: True Deployment (Recommended)
Follow the instructions in `DEPLOYMENT.md` to push your code to **Vercel** (Frontend) and a **VPS/Cloud Run** (Backend).
- Set `NEXT_PUBLIC_BACKEND_URL` in Vercel to your Backend's Domain.
- Set `AI_AGENT_URL` in your Backend VPS to your Agent's private URL.

## Option 2: Temporary Public Access (Tunneling)
If you want to show your "Localhost" app to a friend or client **right now** without deploying, use a Tunnel.

### 1. Backend Controller (Port 8000)
Expose your backend so the public frontend can reach it.
```bash
# Install localtunnel globally
npm install -g localtunnel

# Expose Port 8000
lt --port 8000 --subdomain my-backend-api
```
*Your Backend is now at: `https://my-backend-api.loca.lt`*

### 2. Frontend (Port 3000)
Expose your frontend.
```bash
# Update .env.local first!
# NEXT_PUBLIC_BACKEND_URL=https://my-backend-api.loca.lt

# Expose Port 3000
lt --port 3000 --subdomain my-awesome-chatbot
```
*Your App is now at: `https://my-awesome-chatbot.loca.lt`*

## How the Code Handles This
We updated the code to look for these Environment Variables:
1. **Frontend Proxy**: Uses `BACKEND_API_URL` to know where to send API requests.
2. **Frontend UI**: Uses `NEXT_PUBLIC_BACKEND_URL` for Status checks and Event Feeds.
3. **Backend Controller**: Uses `AI_AGENT_URL` to find the Agent (Port 8001).

By setting these variables in your OS or `.env` files, "Localhost" is effectively removed.
