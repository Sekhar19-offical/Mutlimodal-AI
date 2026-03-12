
import httpx
import asyncio

async def test_agent_reachable():
    url = "http://127.0.0.1:8001/health"
    try:
        async with httpx.AsyncClient() as client:
            resp = await client.get(url, timeout=5)
            print(f"Status: {resp.status_code}")
            print(f"Body: {resp.text}")
    except Exception as e:
        print(f"Error reaching agent: {e}")

if __name__ == "__main__":
    asyncio.run(test_agent_reachable())
