
import os
import sys
# Add backend to path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from app.agent_system.core import Agent
from dotenv import load_dotenv

load_dotenv(dotenv_path='backend/.env')

def test_agent_directly():
    print("Initializing Agent...")
    a = Agent()
    print("Running Agent.run('Hello')...")
    for chunk in a.run("Hello"):
        print(f"CHUNK: {chunk}")
    print("Done.")

if __name__ == "__main__":
    test_agent_directly()
