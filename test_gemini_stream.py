
import os
from google import genai
from dotenv import load_dotenv

load_dotenv()
key = os.getenv("GEMINI_API_KEY")

def test_gemini_stream():
    client = genai.Client(api_key=key)
    try:
        print("Starting stream...")
        response = client.models.generate_content_stream(
            model="gemini-2.0-flash",
            contents="Say 'Hello World'"
        )
        for chunk in response:
            print(f"Chunk: {chunk}")
            # Try different attributes
            if hasattr(chunk, 'text'):
                print(f"Text found: {chunk.text}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_gemini_stream()
