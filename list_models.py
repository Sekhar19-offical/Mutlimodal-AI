
import google.generativeai as genai
import os
from dotenv import load_dotenv
import sys

# Try multiple locations for .env
env_paths = [
    'backend/.env',
    '.env',
    'd:/chatbot/backend/.env'
]

key = None
for p in env_paths:
    if os.path.exists(p):
        load_dotenv(p)
        key = os.getenv("GEMINI_API_KEY")
        if key:
            print(f"Loaded key from {p}")
            break

if not key:
    print("Could not find GEMINI_API_KEY")
    sys.exit(1)

genai.configure(api_key=key)

print("Listing supported models...")
try:
    models = genai.list_models()
    for m in models:
        # Check if it supports generateContent
        if 'generateContent' in m.supported_generation_methods:
            print(f"Model: {m.name}")
except Exception as e:
    print(f"Error listing models: {e}")
