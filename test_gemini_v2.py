
import os
from google import genai
from dotenv import load_dotenv

load_dotenv()
key = os.getenv("GEMINI_API_KEY")

def test_gemini_v2():
    # Attempt to force the use of the Developer API
    try:
        # Note: In the new SDK, providing just api_key should work for the Developer API
        client = genai.Client(api_key=key) 
        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents="Hello"
        )
        print(f"Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_gemini_v2()
