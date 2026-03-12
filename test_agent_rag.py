
import asyncio
import sys
import os

# Set up path to include d:\chatbot\backend
sys.path.append(r"d:\chatbot\backend")

from app.agent_system.core import Agent

async def test_agent_rag():
    cortex = Agent()
    query = "What is the specialized knowledge about AI in the vault?"
    print(f"TESTRUN: Querying Agent with: {query}")
    
    # Mocking classifier to ensure 'factual' intent
    from app.agent_system.query_classifier import classifier
    original_classify = classifier.classify
    classifier.classify = lambda q: {
        "primary_intent": "factual", 
        "confidence": 1.0, 
        "is_time_sensitive": False, 
        "recommended_tools": ["rag_search"],
        "reasoning_hint": "Test reasoning"
    }

    # Mocking RAGPipeline.query to simulate document content
    from app.rag.pipeline.rag_pipeline import RAGPipeline
    original_rag_query = RAGPipeline.query
    async def mock_rag_query(self, q, k=3):
        return "[Source 1]: Cortex is an industrial-grade AI system with specialized RAG capabilities."
    RAGPipeline.query = mock_rag_query

    print("TESTRUN: Running agent...")
    async for chunk in cortex.run(query):
        print(f"AGENT CHUNK: {chunk}")
    
    # Restore
    classifier.classify = original_classify
    RAGPipeline.query = original_rag_query

if __name__ == "__main__":
    asyncio.run(test_agent_rag())
