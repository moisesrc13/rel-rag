from functools import cached_property

from google.adk.agents import LlmAgent
from google.adk.models import Gemini
from google.adk.tools import VertexAiSearchTool, agent_tool
from google.genai import Client


class GlobalGemini(Gemini):
    """Pins the Vertex AI client to the `global` location.

    gemini-3 series models are only served from `global`; the default ADK
    `Gemini` integration constructs a `google.genai.Client` whose location
    defaults to the AgentEngine instance's region (e.g. `us-central1`) and
    fails with model-not-found for these models. Subclassing per the override
    pattern documented on `google.adk.models.google_llm.Gemini` lets the agent
    keep running in its regional AgentEngine instance while routing the model
    request to the global endpoint.
    """

    @cached_property
    def api_client(self) -> Client:
        return Client(vertexai=True, location="global")


relant_conversational_agent_vertex_ai_search_agent = LlmAgent(
    name="relant_conversational_agent_vertex_ai_search_agent",
    model=GlobalGemini(model="gemini-3.5-flash"),
    description=("Agent specialized in performing Vertex AI Search."),
    sub_agents=[],
    instruction="Use the VertexAISearchTool to find information using Vertex AI Search.",
    tools=[
        VertexAiSearchTool(
            data_store_id="projects/relant-rag-494516/locations/global/collections/default_collection/dataStores/relant-rag-bigquery-datastore-v2_1782258681245"
        )
    ],
)
root_agent = LlmAgent(
    name="relant_conversational_agent",
    model=GlobalGemini(model="gemini-3.5-flash"),
    description=("Relant conversation agent for dose and spray products"),
    sub_agents=[],
    instruction="You are an expert support analyst assistant on valve and pumping systems.\nThe application of the pumping systems include: automotive, robotics and industrial spraying.\nYour task is to help our technical support team to answer questions\nrelated to maintenance, warranty, installation, operation, use cases and possible errors\non our pumping systems.",
    tools=[agent_tool.AgentTool(agent=relant_conversational_agent_vertex_ai_search_agent)],
)
