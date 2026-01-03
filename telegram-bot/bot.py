import logging
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import (
    Application,
    CommandHandler,
    MessageHandler,
    CallbackQueryHandler,
    ConversationHandler,
    ContextTypes,
    filters
)
from config import config
from agent import CarpoolAgent
from api_client import api_client

# Enable logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Conversation states
LOGIN, REGISTER, CHATTING = range(3)

# Store user sessions
user_sessions = {}

class CarpoolBot:
    def __init__(self):
        self.application = Application.builder().token(config.TELEGRAM_BOT_TOKEN).build()
        self._setup_handlers()
    
    def _setup_handlers(self):
        """Setup all command and message handlers"""
        
        # Conversation handler for login/register
        auth_conv_handler = ConversationHandler(
            entry_points=[CommandHandler('start', self.start_command)],
            states={
                LOGIN: [MessageHandler(filters.TEXT & ~filters.COMMAND, self.handle_login)],
                REGISTER: [MessageHandler(filters.TEXT & ~filters.COMMAND, self.handle_register)],
            },
            fallbacks=[CommandHandler('cancel', self.cancel_command)]
        )
        
        self.application.add_handler(auth_conv_handler)
        
        # Command handlers
        self.application.add_handler(CommandHandler('help', self.help_command))
        self.application.add_handler(CommandHandler('search', self.search_command))
        self.application.add_handler(CommandHandler('offer', self.offer_command))
        self.application.add_handler(CommandHandler('mycarpools', self.mycarpools_command))
        self.application.add_handler(CommandHandler('rewards', self.rewards_command))
        self.application.add_handler(CommandHandler('carbon', self.carbon_command))
        self.application.add_handler(CommandHandler('logout', self.logout_command))
        
        # Callback query handler for inline buttons
        self.application.add_handler(CallbackQueryHandler(self.button_callback))
        
        # Message handler for natural language processing
        self.application.add_handler(
            MessageHandler(filters.TEXT & ~filters.COMMAND, self.handle_message)
        )
    
    async def start_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Handle /start command"""
        user_id = update.effective_user.id
        
        if user_id in user_sessions:
            await update.message.reply_text(
                f"Welcome back, {update.effective_user.first_name}! 👋\n\n"
                "I'm your AI-powered carpooling assistant. Just tell me what you need:\n"
                "• 'Find a ride to VESIT tomorrow'\n"
                "• 'Show my carpools'\n"
                "• 'How much CO₂ have I saved?'\n"
                "• 'Offer my car for Chembur to BKC'\n\n"
                "I'll understand and help you!"
            )
            return ConversationHandler.END
        
        keyboard = [
            [InlineKeyboardButton("🔐 Login", callback_data='login')],
            [InlineKeyboardButton("📝 Register", callback_data='register')]
        ]
        reply_markup = InlineKeyboardMarkup(keyboard)
        
        await update.message.reply_text(
            "🌱 Welcome to EcoPool Carpooling Bot!\n\n"
            "I'm an AI agent that helps you find ridemates, offer rides, "
            "track your carbon savings, and manage carpools - all through natural conversation!\n\n"
            "Please login or register to continue:",
            reply_markup=reply_markup
        )
        
        return ConversationHandler.END
    
    async def button_callback(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Handle button callbacks"""
        query = update.callback_query
        await query.answer()
        
        if query.data == 'login':
            await query.edit_message_text(
                "🔐 Login\n\n"
                "Please send your credentials in this format:\n"
                "email@example.com password"
            )
            return LOGIN
        
        elif query.data == 'register':
            await query.edit_message_text(
                "📝 Register\n\n"
                "Please send your details in this format:\n"
                "email@company.com password FullName OrganizationName"
            )
            return REGISTER
    
    async def handle_login(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Handle login"""
        try:
            parts = update.message.text.split()
            if len(parts) != 2:
                await update.message.reply_text(
                    "❌ Invalid format. Please use:\nemail@example.com password"
                )
                return LOGIN
            
            email, password = parts
            result = api_client.login(email, password)
            
            if 'token' in result:
                user_id = update.effective_user.id
                user_sessions[user_id] = {
                    'token': result['token'],
                    'email': email,
                    'agent': CarpoolAgent(result['token'])
                }
                
                await update.message.reply_text(
                    f"✅ Login successful!\n\n"
                    f"Hi {result.get('name', 'there')}! I'm your AI carpooling assistant.\n\n"
                    f"Try saying:\n"
                    f"• 'Find me a ride to VESIT tomorrow at 9 AM'\n"
                    f"• 'I want to offer my car for pooling'\n"
                    f"• 'Show my carbon savings'\n\n"
                    f"Just talk naturally - I'll understand!"
                )
                return ConversationHandler.END
            else:
                await update.message.reply_text(
                    "❌ Login failed. Please check your credentials and try again."
                )
                return LOGIN
                
        except Exception as e:
            logger.error(f"Login error: {e}")
            await update.message.reply_text(
                "❌ An error occurred. Please try again."
            )
            return LOGIN
    
    async def handle_register(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Handle registration"""
        try:
            parts = update.message.text.split()
            if len(parts) < 4:
                await update.message.reply_text(
                    "❌ Invalid format. Please use:\n"
                    "email@company.com password FullName OrganizationName"
                )
                return REGISTER
            
            email = parts[0]
            password = parts[1]
            name = parts[2]
            organization = ' '.join(parts[3:])
            
            user_data = {
                'email': email,
                'password': password,
                'name': name,
                'organization': organization
            }
            
            result = api_client.register(user_data)
            
            if 'token' in result or result.get('status') == 'success':
                await update.message.reply_text(
                    "✅ Registration successful!\n\n"
                    "Please login using /start"
                )
                return ConversationHandler.END
            else:
                await update.message.reply_text(
                    f"❌ Registration failed: {result.get('message', 'Unknown error')}"
                )
                return REGISTER
                
        except Exception as e:
            logger.error(f"Registration error: {e}")
            await update.message.reply_text(
                "❌ An error occurred. Please try again."
            )
            return REGISTER
    
    async def handle_message(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Handle natural language messages with AI agent"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text(
                "Please login first using /start"
            )
            return
        
        # Show typing indicator
        await context.bot.send_chat_action(
            chat_id=update.effective_chat.id,
            action="typing"
        )
        
        # Get AI agent response
        agent = user_sessions[user_id]['agent']
        user_message = update.message.text
        
        try:
            # Agent processes message and autonomously decides actions
            response = agent.process_message(user_message)
            await update.message.reply_text(response)
            
        except Exception as e:
            logger.error(f"Agent error: {e}")
            await update.message.reply_text(
                "I encountered an issue processing your request. Could you try rephrasing?"
            )
    
    async def search_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Quick search command"""
        await update.message.reply_text(
            "🔍 Search for Carpools\n\n"
            "Just tell me where you want to go!\n\n"
            "Example: 'Find me a ride from Chembur to VESIT tomorrow at 9 AM'"
        )
    
    async def offer_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Quick offer ride command"""
        await update.message.reply_text(
            "🚗 Offer Your Ride\n\n"
            "Tell me your route and I'll create a carpool!\n\n"
            "Example: 'I can offer my car from Dadar to BKC tomorrow at 8:30 AM, 3 seats available'"
        )
    
    async def mycarpools_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Show user's carpools"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        agent = user_sessions[user_id]['agent']
        response = agent._get_my_carpools()
        await update.message.reply_text(response)
    
    async def rewards_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Show rewards"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        agent = user_sessions[user_id]['agent']
        response = agent._get_rewards()
        await update.message.reply_text(response)
    
    async def carbon_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Show carbon stats"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        agent = user_sessions[user_id]['agent']
        response = agent._get_carbon_stats()
        await update.message.reply_text(response)
    
    async def help_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Show help message"""
        help_text = """
🤖 EcoPool AI Assistant Help

I'm an intelligent agent that understands natural language! Just talk to me normally.

📝 What I can do:
• Find carpools for you
• Help you offer rides
• Show your carpools
• Track CO₂ savings
• Manage rewards

💬 Example Messages:
"Find me a ride to VESIT tomorrow"
"I want to offer my car for pooling"
"Show my carbon savings"
"What are my rewards?"
"List my active carpools"

⚡ Quick Commands:
/search - Search for rides
/offer - Offer your ride
/mycarpools - Your carpools
/rewards - Your rewards
/carbon - CO₂ stats
/logout - Logout
/help - Show this message
        """
        await update.message.reply_text(help_text)
    
    async def logout_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Logout user"""
        user_id = update.effective_user.id
        if user_id in user_sessions:
            del user_sessions[user_id]
            await update.message.reply_text("✅ Logged out successfully!")
        else:
            await update.message.reply_text("You're not logged in.")
    
    async def cancel_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Cancel current operation"""
        await update.message.reply_text("Operation cancelled.")
        return ConversationHandler.END
    
    def run(self):
        """Start the bot"""
        logger.info("Starting bot...")
        self.application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == '__main__':
    bot = CarpoolBot()
    bot.run()
