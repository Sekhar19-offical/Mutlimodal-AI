
import requests
import json
import time

def test_chat():
    agent_url = "http://localhost:8001/agent/chat"
    payload = {
        "query": "Hello",
        "session_id": "test@example.com",
        "model": "gemini",
        "personality": "professional",
        "custom_instructions": ""
    }
    
    print(f"Testing Agent Service directly at {agent_url}...")
    try:
        start_time = time.time()
        response = requests.post(agent_url, data=payload, stream=True)
        print(f"Status Code: {response.status_code}")
        print(f"Time to headers: {time.time() - start_time:.2f}s")
        
        found_content = False
        for chunk in response.iter_content(chunk_size=None):
            if chunk:
                print(f"Chunk received: {chunk.decode('utf-8')}")
                found_content = True
        
        if not found_content:
            print("No content received from stream.")
            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_chat()
