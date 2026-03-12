
import httpx
import asyncio
import io
from PIL import Image

async def test_full_vision_path():
    # Simulate main backend calling agent backend
    url = "http://127.0.0.1:8001/agent/chat"
    
    # Create a dummy image
    img = Image.new('RGB', (100, 100), color = (73, 109, 137))
    img_byte_arr = io.BytesIO()
    img.save(img_byte_arr, format='PNG')
    img_byte_arr = img_byte_arr.getvalue()
    
    files = {"file": ("test.png", img_byte_arr, "image/png")}
    data = {
        "query": "describe this image",
        "session_id": "test_user",
        "model": "gemini",
        "personality": "professional"
    }
    
    print("Sending Vision Request to Agent (8001)...")
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            async with client.stream("POST", url, data=data, files=files) as r:
                print(f"Status Code: {r.status_code}")
                if r.status_code != 200:
                    print(f"Error: {await r.aread()}")
                    return
                
                async for chunk in r.aiter_text():
                    print(chunk, end="", flush=True)
    except Exception as e:
        print(f"Connection Error: {e}")

if __name__ == "__main__":
    asyncio.run(test_full_vision_path())
