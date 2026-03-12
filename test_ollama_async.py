import asyncio
import logging
import sys
import os

# Set up path to include d:\chatbot\backend
sys.path.append(r"d:\chatbot\backend")

from app.ollama_client import generate_ollama_stream

async def main():
    logging.basicConfig(level=logging.INFO)
    messages = [{"role": "user", "parts": ["Hi, tell me a 1-word joke."]}]
    print("Starting stream...")
    async for chunk in generate_ollama_stream(messages, model_name="qwen3"):
        print(f"GOT CHUNK: {chunk}")
    print("Done.")

if __name__ == "__main__":
    asyncio.run(main())
