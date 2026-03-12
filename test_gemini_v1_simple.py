
import os
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
key = os.getenv("GEMINI_API_KEY")

def test():
    print(f"Key found: {key[:5]}...{key[-5:]}" if key else "No Key")
    genai.configure(api_key=key)
    try:
        model = genai.GenerativeModel('gemini-1.5-flash')
        response = model.generate_content("Hello", stream=True)
        for chunk in response:
            print(f"TEXT: {chunk.text}")
    except Exception as e:
        print(f"ERROR: {e}")

if __name__ == "__main__":
    test()
