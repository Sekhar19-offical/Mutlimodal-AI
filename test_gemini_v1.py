
import os
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
key = os.getenv("GEMINI_API_KEY")

def test_gemini_v1():
    genai.configure(api_key=key)
    model = genai.GenerativeModel('gemini-1.5-flash')
    try:
        print("Testing Gemini v1 Stream...")
        response = model.generate_content("Say 'Hello v1'", stream=True)
        for chunk in response:
            print(f"Chunk text: {chunk.text}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_gemini_v1()
