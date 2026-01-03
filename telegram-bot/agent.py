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
                description="Search for available carpools (Carpooling or Auto-rickshaw mode). Input should be JSON with 'pickup', 'dropoff', 'date', 'seats', 'mode' fields. Mode can be 'carpool' or 'auto'. Use this when user wants to find ridemates."
            ),
            Tool(
                name="GetMyCarpools",
                func=self._get_my_carpools,
                description="Get user's active and upcoming carpools. No input required. Use when user asks about their rides or carpools."
            ),
            Tool(
                name="GetDiamondBalance",
                func=self._get_diamond_balance,
                description="Get user's Carbon Crystal (diamond) balance. No input required. Use when user asks about diamonds, crystals, or balance."
            ),
            Tool(
                name="GetRewards",
                func=self._get_rewards,
                description="Get user's reward points and marketplace. No input required. Use when user asks about rewards, products, or marketplace."
            ),
            Tool(
                name="TradeDiamonds",
                func=self._trade_diamonds,
                description="Trade/send diamonds to another user. Input should be JSON with 'recipient_email' and 'amount' fields. Use when user wants to send diamonds."
            ),
            Tool(
                name="DonateToNGO",
                func=self._donate_to_ngo,
                description="Donate diamonds to NGO. Input should be JSON with 'ngo_name' and 'amount' fields. Use when user wants to donate."
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
            mode = params.get('mode', 'carpool')
            results = api_client.search_rides(
                pickup=params.get('pickup'),
                dropoff=params.get('dropoff'),
                date=params.get('date'),
                seats=params.get('seats', 1)
            )
            
            if not results:
                return f"No {mode}s found matching your criteria. Try different locations or dates."
            
            # Format results with Gen-Z vibe
            mode_emoji = "🚗" if mode == 'carpool' else "🛺"
            tagline = "Slay the commute, split the bills 💅" if mode == 'carpool' else "Squad up & save that drip money 🛺"
            
            response = f"{mode_emoji} Found {len(results)} ridemates! {tagline}\n\n"
            for idx, ride in enumerate(results, 1):
                response += f"{idx}. {ride['pickup']} → {ride['dropoff']}\n"
                response += f"   Time: {ride['time']}\n"
                response += f"   Seats: {ride['available_seats']}\n"
                response += f"   Organization: {ride.get('organization', 'N/A')}\n"
                response += f"   CO₂ Saved: {ride.get('co2_saved', 0)} kg\n"
                response += f"   💎 Earn: ~150 diamonds\n\n"
            
            return response
        except Exception as e:
            return f"Error searching carpools: {str(e)}"
    
    def _offer_ride(self, input_str: str) -> str:
        """Removed - not an Ola/Uber app"""
        return "This feature is not available. We're a carpooling community, not a ride-hailing service!"
    
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
            
            response = f"🎁 Rewards Marketplace\n\n"
            response += f"💎 Your Balance: {rewards.get('diamonds', 1250)} diamonds\n\n"
            response += f"Mock Products:\n"
            response += f"🎧 Wireless Headphones - 450💎 (20% OFF)\n"
            response += f"☕ Coffee Voucher - 150💎 (FREE)\n"
            response += f"🎬 Movie Tickets - 300💎 (2 for 1)\n"
            response += f"💪 Gym Membership - 800💎 (30% OFF)\n"
            response += f"📚 Book Store Voucher - 400💎 (₹500 OFF)\n"
            response += f"💆 Spa Package - 650💎 (25% OFF)\n\n"
            response += f"Use the app to redeem! 📱"
            
            return response
        except Exception as e:
            return f"Error fetching rewards: {str(e)}"
    
    def _get_diamond_balance(self, _: str = "") -> str:
        """Get user's diamond balance"""
        try:
            balance = api_client.get_rewards()
            
            response = f"💎 Your Carbon Crystals\n\n"
            response += f"Balance: {balance.get('diamonds', 1250)} 💎\n"
            response += f"Total Earned: {balance.get('total_earned', 2340)} 💎\n"
            response += f"Total Spent: {balance.get('total_spent', 1090)} 💎\n\n"
            response += f"Recent Activity:\n"
            response += f"• Received from Sarah: +50 💎\n"
            response += f"• Paid for ride: +150 💎\n"
            response += f"• Redeemed coffee: -150 💎\n\n"
            response += f"Keep carpooling to earn more! 🚗"
            
            return response
        except Exception as e:
            return f"Error fetching diamond balance: {str(e)}"
    
    def _trade_diamonds(self, input_str: str) -> str:
        """Trade diamonds with another user"""
        try:
            params = json.loads(input_str)
            recipient = params.get('recipient_email')
            amount = params.get('amount')
            
            # Mock implementation
            response = f"✅ Diamond Trade Successful!\n\n"
            response += f"Sent: {amount} 💎\n"
            response += f"To: {recipient}\n\n"
            response += f"New Balance: {1250 - amount} 💎\n"
            response += f"Transaction ID: TXN{hash(recipient) % 10000}\n\n"
            response += f"Your friend will receive the diamonds shortly!"
            
            return response
        except Exception as e:
            return f"Error trading diamonds: {str(e)}"
    
    def _donate_to_ngo(self, input_str: str) -> str:
        """Donate diamonds to NGO"""
        try:
            params = json.loads(input_str)
            ngo = params.get('ngo_name', '').lower()
            amount = params.get('amount')
            
            ngo_map = {
                'green earth': {'emoji': '🌳', 'impact': 'trees planted'},
                'clean air': {'emoji': '🌫️', 'impact': 'sensors installed'},
                'solar': {'emoji': '☀️', 'impact': 'solar panels'},
                'ocean': {'emoji': '🌊', 'impact': 'kg plastic removed'}
            }
            
            ngo_info = ngo_map.get(ngo, {'emoji': '🌱', 'impact': 'impact'})
            
            response = f"✅ Donation Successful!\n\n"
            response += f"{ngo_info['emoji']} {ngo.title()}\n"
            response += f"Donated: {amount} 💎\n"
            response += f"Impact: {amount // 50} {ngo_info['impact']}\n\n"
            response += f"Thank you for making a difference! 🌍\n"
            response += f"New Balance: {1250 - amount} 💎"
            
            return response
        except Exception as e:
            return f"Error donating: {str(e)}"
    
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
