
import asyncio
import time
import os
import sys

# Mock some things for the test
sys.path.append(os.path.join(os.getcwd(), "backend"))

from app.agent_system.core import Agent

async def measure_latency():
    print("--- LATENCY MEASUREMENT ---")
    agent = Agent()
    
    # Give some time for background warmup (though test might finish before it's done)
    # await asyncio.sleep(2) 
    
    query = "What is the capital of France?"
    print(f"Query: {query}")
    
    start_time = time.time()
    first_token_time = None
    
    async for chunk in agent.run(query):
        if first_token_time is None:
            first_token_time = time.time()
            latency = (first_token_time - start_time) * 1000
            print(f"⏱️ TIME TO FIRST TOKEN: {latency:.2f} ms")
        # print(chunk, end="", flush=True)
    
    total_time = (time.time() - start_time) * 1000
    print(f"\n\n⏱️ TOTAL GENERATION TIME: {total_time:.2f} ms")

if __name__ == "__main__":
    asyncio.run(measure_latency())
