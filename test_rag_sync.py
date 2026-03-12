
import sys
import os

# Set up path to include d:\chatbot\backend
sys.path.append(r"d:\chatbot\backend")

from app.rag.pipeline.rag_pipeline import RAGPipeline

def test_rag():
    pipeline = RAGPipeline()
    # Mocking search results so it doesn't return "I don't have enough information"
    import app.memory.vector as vector
    original_search = vector.search_with_score
    vector.search_with_score = lambda q, k: [{"text": "This is a test document content about AI.", "score": 0.9}]
    
    print("Querying RAG...")
    result = pipeline.query("What is AI?")
    print(f"RESULT TYPE: {type(result)}")
    print(f"RESULT: {result}")
    
    vector.search_with_score = original_search

if __name__ == "__main__":
    test_rag()
