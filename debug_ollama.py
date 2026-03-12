
import ollama
import sys

print("Checking available models...")
try:
    models = ollama.list()
    print("Available models:", models)
except Exception as e:
    print(f"Failed to list models: {e}")
    sys.exit(1)

MODEL = "llama3.2:latest"
prompt = "hello, are you working?"

print(f"\nAttempting to chat with model: {MODEL}")
try:
    stream = ollama.chat(
        model=MODEL,
        messages=[{"role": "user", "content": prompt}],
        stream=True
    )
    print("Stream connected. Waiting for chunks...")
    for chunk in stream:
        content = chunk["message"]["content"]
        print(f"Chunk received: {content}", end="", flush=True)
    print("\nStream finished.")
except Exception as e:
    print(f"\nError during chat: {e}")

    # Try fallback to just "llama3.2" if "llama3.2:latest" failed
    if "model" in str(e).lower() or "not found" in str(e).lower():
         print("\nRetrying with 'llama3.2'...")
         try:
            stream = ollama.chat(
                model="llama3.2",
                messages=[{"role": "user", "content": prompt}],
                stream=True
            )
            for chunk in stream:
                content = chunk["message"]["content"]
                print(f"Chunk received: {content}", end="", flush=True)
            print("\nStream finished.")
         except Exception as e2:
             print(f"\nRetry failed: {e2}")
