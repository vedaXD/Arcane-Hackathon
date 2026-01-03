from typing import Dict, List, Optional
from langchain.agents import initialize_agent, Tool, AgentType
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.memory import ConversationBufferMemory
from api_client import api_client
from config import config
import json

class CarpoolAgent:
    """Agentic AI for autonomous carpooling assistance"""
    
    def __init__(self, user_token: Optional[str] = None):
        self.user_token = user_token
        if user_token:
            api_client.set_auth_token(user_token)
        
        # Initialize LLM with Google Gemini
        self.llm = ChatGoogleGenerativeAI(
            model="gemini-pro",
            temperature=0.7,
            google_api_key=config.GEMINI_API_KEY
        )
        
        # Initialize memory for conversation context
        self.memory = ConversationBufferMemory(
            memory_key="chat_history",
            return_messages=True
        )
        
        # Define tools the agent can use
        self.tools = self._create_tools()
        
        # Initialize agent
        self.agent = initialize_agent(
            tools=self.tools,
            llm=self.llm,
            agent=AgentType.OPENAI_FUNCTIONS,
            memory=self.memory,
            verbose=True,
            handle_parsing_errors=True
        )
    
    def _create_tools(self) -> List[Tool]:
        """Create tools for the agent to use"""
        return [
            Tool(
                name="SearchCarpools",
                func=self._search_carpools,
                description="Search for available carpools. Input should be JSON with 'pickup', 'dropoff', 'date', 'seats' fields. Use this when user wants to find ridemates."
            ),
            Tool(
                name="OfferRide",
                func=self._offer_ride,
                description="Create a new carpool offering. Input should be JSON with 'pickup', 'dropoff', 'date', 'time', 'seats_available', 'vehicle_type' fields. Use when user wants to offer their vehicle."
            ),
            Tool(
                name="GetMyCarpools",
                func=self._get_my_carpools,
                description="Get user's active and upcoming carpools. No input required. Use when user asks about their rides or carpools."
            ),
            Tool(
                name="GetRewards",
                func=self._get_rewards,
                description="Get user's reward points and redemption options. No input required. Use when user asks about rewards, points, or benefits."
            ),
            Tool(
                name="GetCarbonStats",
                func=self._get_carbon_stats,
                description="Get user's carbon savings and environmental impact. No input required. Use when user asks about CO2 savings, environmental impact, or sustainability."
            ),
            Tool(
                name="GetPopularLocations",
                func=self._get_popular_locations,
                description="Get list of popular pickup/drop locations. No input required. Use when user needs location suggestions."
            ),
        ]
    
    def _search_carpools(self, input_str: str) -> str:
        """Search for available carpools"""
        try:
            params = json.loads(input_str)
            results = api_client.search_rides(
                pickup=params.get('pickup'),
                dropoff=params.get('dropoff'),
                date=params.get('date'),
                seats=params.get('seats', 1)
            )
            
            if not results:
                return "No carpools found matching your criteria. Try different locations or dates."
            
            # Format results
            response = f"Found {len(results)} available carpools:\n\n"
            for idx, ride in enumerate(results, 1):
                response += f"{idx}. {ride['pickup']} → {ride['dropoff']}\n"
                response += f"   Time: {ride['time']}\n"
                response += f"   Seats: {ride['available_seats']}\n"
                response += f"   Organization: {ride.get('organization', 'N/A')}\n"
                response += f"   CO₂ Saved: {ride.get('co2_saved', 0)} kg\n\n"
            
            return response
        except Exception as e:
            return f"Error searching carpools: {str(e)}"
    
    def _offer_ride(self, input_str: str) -> str:
        """Create new carpool offering"""
        try:
            params = json.loads(input_str)
            result = api_client.offer_ride(params)
            
            return f"✅ Carpool created successfully!\n\nRoute: {params['pickup']} → {params['dropoff']}\nDate: {params['date']}\nTime: {params['time']}\nSeats Available: {params['seats_available']}\n\nYour carpool is now visible to colleagues searching for rides!"
        except Exception as e:
            return f"Error creating carpool: {str(e)}"
    
    def _get_my_carpools(self, _: str = "") -> str:
        """Get user's carpools"""
        try:
            carpools = api_client.get_my_carpools()
            
            if not carpools:
                return "You don't have any active carpools. Search for ridemates or offer a ride!"
            
            response = f"Your Active Carpools ({len(carpools)}):\n\n"
            for idx, carpool in enumerate(carpools, 1):
                response += f"{idx}. {carpool['route']}\n"
                response += f"   Status: {carpool['status']}\n"
                response += f"   Members: {carpool['member_count']}\n"
                response += f"   Next Ride: {carpool['next_ride_date']}\n\n"
            
            return response
        except Exception as e:
            return f"Error fetching carpools: {str(e)}"
    
    def _get_rewards(self, _: str = "") -> str:
        """Get user's rewards"""
        try:
            rewards = api_client.get_rewards()
            
            response = f"💰 Your Rewards\n\n"
            response += f"Points: {rewards.get('points', 0)}\n"
            response += f"Redeemable: ₹{rewards.get('redeemable_amount', 0)}\n"
            response += f"Total Earned: {rewards.get('total_earned', 0)} points\n\n"
            response += f"Recent Activity:\n"
            for activity in rewards.get('recent', [])[:3]:
                response += f"• {activity['description']}: +{activity['points']} points\n"
            
            return response
        except Exception as e:
            return f"Error fetching rewards: {str(e)}"
    
    def _get_carbon_stats(self, _: str = "") -> str:
        """Get carbon savings statistics"""
        try:
            stats = api_client.get_carbon_stats()
            
            response = f"🌱 Your Environmental Impact\n\n"
            response += f"CO₂ Saved: {stats.get('co2_saved', 0)} kg\n"
            response += f"Equivalent Trees: {stats.get('trees_equivalent', 0)}\n"
            response += f"Total Rides: {stats.get('total_rides', 0)}\n"
            response += f"This Month: {stats.get('monthly_co2', 0)} kg CO₂\n\n"
            response += f"You're doing great! Keep carpooling to save more."
            
            return response
        except Exception as e:
            return f"Error fetching carbon stats: {str(e)}"
    
    def _get_popular_locations(self, _: str = "") -> str:
        """Get popular locations"""
        try:
            locations = api_client.get_popular_locations()
            
            response = "📍 Popular Locations:\n\n"
            for loc in locations[:10]:
                response += f"• {loc['name']}\n"
            
            return response
        except Exception as e:
            return f"Error fetching locations: {str(e)}"
    
    def process_message(self, user_message: str) -> str:
        """Process user message with agentic AI"""
        try:
            # Agent autonomously decides which tools to use
            response = self.agent.run(user_message)
            return response
        except Exception as e:
            return f"I encountered an error: {str(e)}. Could you rephrase your request?"
    
    def reset_conversation(self):
        """Clear conversation memory"""
        self.memory.clear()
