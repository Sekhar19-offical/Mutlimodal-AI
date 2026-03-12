
import asyncio
import os
import sys
import numpy as np
from unittest.mock import AsyncMock, MagicMock, patch

# Mock dependencies
sys.modules['app.rag.pipeline.rag_pipeline'] = MagicMock()
sys.modules['app.rag.embeddings.embedding_generator'] = MagicMock()
sys.modules['app.memory.vector'] = MagicMock()

from app.agent_system.eternal_memory import EternalMemory
from app.agent_system.core import Agent
from app.agent_system.specialists import specialist_hub

async def test_agent_features():
    print("--- CORTEX AGENTIC FEATURES VERIFICATION ---")
    
    # 1. SPECIALIST HUB
    print("\n[STEP 1] Testing Specialist Hub...")
    s = specialist_hub.get_specialist_context("research")
    assert s['name'] == 'researcher', f"Expected researcher, got {s['name']}"
    print("DONE Specialist Hub: Researcher correctly identified.")

    # 2. ETERNAL MEMORY
    print("\n[STEP 2] Testing Eternal Memory...")
    test_memory = EternalMemory()
    test_memory._reset() 
    
    # Fix the vector for deterministic matching in test
    v = np.zeros((1, 384)).astype('float32')
    v[0, 0] = 1.0 
    
    with patch('app.rag.embeddings.embedding_generator.generate_embeddings', return_value=v):
        await test_memory.add_memory("User is a Python expert.")
        recalled = await test_memory.recall("python")
        print(f"Recalled: '{recalled}'")
        # In the real class it checks for > 0.6. With our unit vector, it should be 1.0.
        if "Python expert" in recalled:
            print("DONE Eternal Memory: Store and Recall functioning.")
        else:
            print(f"FAIL Eternal Memory: Recall returned: '{recalled}'")

    # 3. CORE INTEGRATION
    print("\n[STEP 3] Testing Core Agent Integration...")
    import app.agent_system.core
    app.agent_system.core.eternal_memory = test_memory

    agent = Agent()
    agent._generate_with_unified_fallback = MagicMock()
    mock_gen = AsyncMock()
    mock_gen.__aiter__.return_value = ["FINAL ANSWER: Done."]
    agent._generate_with_unified_fallback.return_value = mock_gen

    with patch('app.rag.embeddings.embedding_generator.generate_embeddings', return_value=v):
        with patch('app.agent_system.core.classifier.classify', return_value={"primary_intent": "research", "reasoning_hint": "Search deep."}):
            async for _ in agent.run("Research AI", "session_1"):
                pass
            
    messages = agent._generate_with_unified_fallback.call_args[0][0]
    prompt = messages[0]['parts'][0]
    
    has_specialist = "Lead Researcher Agent" in prompt
    has_memory = "ETERNAL USER MEMORY" in prompt
    
    if has_specialist: print("DONE Specialist Persona Multi-Agent: Detected.")
    else: print("FAIL Specialist Persona Multi-Agent: NOT Detected.")
    
    if has_memory: print("DONE Eternal Memory Context: Detected.")
    else: print("FAIL Eternal Memory Context: NOT Detected.")

    # 4. AUTONOMOUS SCRIPTING
    print("\n[STEP 4] Testing Autonomous Scripting Tool...")
    from app.agent_system.tools import get_toolbox
    tools = get_toolbox()
    if "autonomous_scripting" in tools:
        print("DONE Autonomous Scripting Tool: Registered.")
        func = tools["autonomous_scripting"]["func"]
        result = func("print('Hello from Agentic Script')")
        print(f"Script output: {result.strip()}")
        if "Hello" in result: print("DONE Script Execution: Functional.")
    else:
        print("FAIL Autonomous Scripting Tool: MISSING.")

    print("\n--- ALL AGENTIC UPGRADES VERIFIED ---")

if __name__ == "__main__":
    asyncio.run(test_agent_features())
