
import os
from google import genai
from dotenv import load_dotenv

load_dotenv()
key = os.getenv("GEMINI_API_KEY")

def test_gemini():
    if not key:
        print("No API Key found")
        return
    client = genai.Client(api_key=key)
    try:
        print("Testing Gemini 2.0 Flash...")
        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents="Say 'Gemini is online'"
        )
        print(f"Response: {response.text}")
    except Exception as e:
        print(f"Gemini Error: {e}")

if __name__ == "__main__":
    test_gemini()
