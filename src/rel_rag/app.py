import os

from google import genai
from google.cloud import bigquery
from google.genai import types

# 1. Initialize the clients
# Note: The GenAI client automatically picks up your GEMINI_API_KEY environment variable,
# or uses your local Google Cloud ADC credentials.
ai_client = genai.Client(vertexai=True)
bq_client = bigquery.Client(project="relant-rag-494516")


def ask_gemini_rag(user_question: str) -> str:
    """
    Retrieves relevant PDF text chunks from BigQuery using Vector Search
    and synthesizes an answer using Gemini Pro.
    """
    # Clean user input to prevent SQL injection or quote breaking
    safe_question = user_question.replace('"', '\\"')

    # 2. Define the BigQuery vector search query
    # This query matches the user question against the pre-computed table embeddings
    search_query = f"""
    SELECT base.content
    FROM VECTOR_SEARCH(
      TABLE `relant-rag-494516.products_embedding_dataset.pdf_embeddings`,
      'embedding',
      (
        SELECT ml_generate_embedding_result AS query_embedding
        FROM ML.GENERATE_EMBEDDING(
          MODEL `relant-rag-494516.products_embedding_dataset.gemini_embedding_model`,
          (SELECT "{safe_question}" AS content)
        )
      ),
      top_k => 3,
      distance_type => 'COSINE'
    );
    """

    try:
        # 3. Retrieve matching text chunks from BigQuery
        query_job = bq_client.query(search_query)
        results = query_job.result()

        # Combine matching document fragments into a single string
        retrieved_chunks = [row.content for row in results]

        if not retrieved_chunks:
            return "No matching documentation found in your corporate bucket."

        context_str = "\n---\n".join(retrieved_chunks)
        # print(f"context \n\n {context_str}")

        # 4. Construct the prompt for Gemini Pro
        system_instruction = (
            "You are an expert support analyst assistant on valve and pumping systems."
            "The application of the pumping systems include: automotive, robotics and industrial spraying."
            "Your task is to help our technical support team to answer questions"
            "related to maintenance, warranty, installation, operation, use cases and possible errors"
            "on our pumping systems."
            "Keep your response concise and under 3 to 5 paragraphs. If you cannot find the answer in the context, say "
            "'I'm sorry, I can't find the information in the company documentation'."
        )

        prompt = f"""
        USER QUESTION: {user_question}

        RETRIEVED CORPORATE CONTEXT:
        {context_str}
        """

        # 5. Call the Gemini Model via the official GenAI SDK
        response = ai_client.models.generate_content(
            model="gemini-3.5-flash",
            contents=prompt,
            config=types.GenerateContentConfig(
                system_instruction=system_instruction,
                temperature=0.2,  # Low temperature keeps answers factual and strictly grounded
                max_output_tokens=8192,
            ),
        )

        return response.text

    except Exception as e:
        return f"An error occurred in the RAG pipeline: {str(e)}"


# =====================================================================
# Example Application Call
# =====================================================================
if __name__ == "__main__":
    user_prompt = "what is the Automatic Spray Valve KA-2?"
    print(f"User Question: {user_prompt}\n")

    final_answer = ask_gemini_rag(user_prompt)
    print(f"Gemini RAG Response:\n{final_answer}")
