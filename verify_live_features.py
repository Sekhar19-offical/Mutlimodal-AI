
import asyncio
import os
import sys

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), "backend"))

from app.agent_system.eternal_memory import eternal_memory

async def verify_real_memory():
    print("Verifying Real Eternal Memory Pipeline...")
    fact = "User is an Advanced AI Engineer working on Cortex Swarm."
    await eternal_memory.add_memory(fact, "professional")
    
    print("Recalling...")
    recalled = await eternal_memory.recall("What is the user's job?")
    print(f"Recalled: {recalled}")
    
    if "Cortex Swarm" in recalled:
        print("SUCCESS: Eternal Memory is LIVE.")
    else:
        print("FAILURE: Eternal Memory recall failed.")

if __name__ == "__main__":
    asyncio.run(verify_real_memory())
