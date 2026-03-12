
# The Best Free Hosting Stack (Free Domains Included)

You don't need to buy a `.com` to have a public, shareable link. You can use the free subdomains provided by cloud hosting platforms.

Here is the recommended **Free Stack** for your application:

## 1. Frontend: Vercel (Recommended)
**Free Domain:** `https://your-app-name.vercel.app`

**How to get it:**
1. Push your code to **GitHub**.
2. Go to [Vercel.com](https://vercel.com) and sign up (Free).
3. "Import Project" -> Select your GitHub Repo.
4. **Build Settings**:
   - Framework: Next.js (Auto-detected).
   - Root Directory: `frontend`.
5. **Deploy**.
6. You instantly get a working URL like `https://multimodal-chatbot-alpha.vercel.app`.

## 2. Backend: Render (Recommended)
**Free Domain:** `https://your-api-name.onrender.com`

**How to get it:**
1. Go to [Render.com](https://render.com) and sign up.
2. Create a **New Web Service**.
3. Connect your GitHub Repo.
4. **Settings**:
   - Root Directory: `backend`.
   - Build Command: `pip install -r requirements.txt`.
   - Start Command: `uvicorn app.main:app --host 0.0.0.0 --port 10000`.
5. **Environment Variables**:
   - Add `GEMINI_API_KEY`, `SECRET_KEY`, etc.
6. **Deploy**.
7. Render gives you `https://my-backend-api.onrender.com`.

## 3. Connecting Them (Crucial Step)

Once both are deployed, you need to introduce them to each other using Environment Variables.

**In Frontend (Vercel Dashboard):**
- Add `NEXT_PUBLIC_BACKEND_URL` = `https://my-backend-api.onrender.com`
- *Redeploy Frontend.*

**In Backend (Render Dashboard):**
- Add `BACKEND_CORS_ORIGINS` = `https://multimodal-chatbot-alpha.vercel.app`
- *Redeploy Backend.*

## Result
You now have a fully public application accessible to anyone in the world, completely for free.
- **Users visit:** `https://multimodal-chatbot-alpha.vercel.app`
- **Internal API:** `https://my-backend-api.onrender.com`
