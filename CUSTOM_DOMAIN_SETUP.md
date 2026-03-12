
# How to Use Your Own .COM Domain

To replace "localhost" or "vercel.app" with your own custom domain (e.g., `www.my-ai-app.com`), follow these steps.

## 1. Purchase a Domain
Go to a registrar like [Namecheap](https://namecheap.com), [GoDaddy](https://godaddy.com), or [Google Domains](https://domains.google) and buy your `.com`.

## 2. Frontend Configuration (Vercel)
If you deployed the Frontend to Vercel:
1. Go to your Project Settings > **Domains**.
2. Type in `www.my-ai-app.com`.
3. Vercel will give you DNS Records (A Record or CNAME).
4. Go to your Registrar (Step 1) and add these records.
5. **Wait 24h** for propagation.

## 3. Backend Configuration (VPS / Cloud)
Your backend needs a subdomain (e.g., `api.my-ai-app.com`).
1. In your Registrar, create an **A Record** for `api` pointing to your VPS IP Address (e.g., `123.45.67.89`).
2. On your VPS, use **Nginx** to listen for this domain (see `DEPLOYMENT.md`).
3. Use **Certbot** to get free HTTPS:
   ```bash
   sudo certbot --nginx -d api.my-ai-app.com
   ```

## 4. Connect Them via Environment Variables
Once domains are live, update your production environment files.

**Backend (.env.production):**
```ini
# Allow your frontend domain to talk to the backend
BACKEND_CORS_ORIGINS=https://www.my-ai-app.com
```

**Frontend-Vercel (Environment Variables):**
```ini
# Point frontend to your new API domain
NEXT_PUBLIC_BACKEND_URL=https://api.my-ai-app.com
```

## Summary
- **User Vists**: `https://www.my-ai-app.com`
- **Frontend Calls**: `https://api.my-ai-app.com`
- **Backend Calls**: Internal Agent Service (Private)
