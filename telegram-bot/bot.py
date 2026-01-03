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
        self.application.add_handler(CommandHandler('mycarpools', self.mycarpools_command))
        self.application.add_handler(CommandHandler('rewards', self.rewards_command))
        self.application.add_handler(CommandHandler('diamonds', self.diamonds_command))
        self.application.add_handler(CommandHandler('trade', self.trade_command))
        self.application.add_handler(CommandHandler('donate', self.donate_command))
        self.application.add_handler(CommandHandler('marketplace', self.marketplace_command))
        self.application.add_handler(CommandHandler('payment', self.payment_command))
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
            welcome_msg = (
                f"🎉 Welcome back, {update.effective_user.first_name}! ✨\n\n"
                "🚗 **EcoPool AI Assistant** - Your Smart Carpooling Companion\n\n"
                "I'm here to make your commute easier, greener, and more social! 🌱\n\n"
                "💬 **Just talk to me naturally! Try saying:**\n"
                "• 'Find me ridemates to VESIT tomorrow at 9 AM'\n"
                "• 'Show my active rides'\n"
                "• 'How many diamonds do I have?'\n"
                "• 'I want to donate to environmental NGOs'\n"
                "• 'What rewards can I get with my diamonds?'\n\n"
                "🌟 **Why EcoPool rocks:**\n"
                "• Save money by sharing rides 💰\n"
                "• Earn Carbon Crystals (diamonds) for eco-rides 💎\n"
                "• Meet awesome people from your organization 👥\n"
                "• Help save the planet, one ride at a time 🌍\n\n"
                "Ready to slay your commute? Just send me a message! 💅"
            )
            await update.message.reply_text(welcome_msg, parse_mode='Markdown')
            return ConversationHandler.END
        
        keyboard = [
            [InlineKeyboardButton("🔐 Login", callback_data='login')],
            [InlineKeyboardButton("📝 Register", callback_data='register')]
        ]
        reply_markup = InlineKeyboardMarkup(keyboard)
        
        welcome_msg = (
            "🌟 **Welcome to EcoPool!** 🌟\n\n"
            "💅 *Slay the Commute, Save the Planet!*\n\n"
            "🤖 I'm your **AI Carpooling Assistant** - think of me as your smart travel buddy! \n\n"
            "✨ **What makes EcoPool special?**\n"
            "🚗 Smart ride-matching for your organization\n"
            "💎 Earn **Carbon Crystals** (diamonds) for eco-friendly rides\n"
            "🎁 Redeem rewards & trade with fellow commuters\n"
            "🌱 Donate diamonds to environmental NGOs\n"
            "📊 Track your personal CO₂ impact\n"
            "💬 Join 24-hour ride chat rooms\n"
            "💳 Easy payments with QR codes\n\n"
            "🎯 **Perfect for:** VESIT students, Tech employees, Daily commuters\n\n"
            "Ready to start your eco-friendly journey? Let's get you set up! 🚀"
        )
        
        await update.message.reply_text(
            welcome_msg,
            reply_markup=reply_markup,
            parse_mode='Markdown'
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
                "email@company.com password FullName\n\n"
                "Note: Use your organization email (e.g., @techcorp.com) to auto-join your organization's carpooling network!"
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
                    f"Hi {result.get('name', 'there')}! I'm your AI carpooling buddy.\n\n"
                    f"Try saying:\n"
                    f"• 'Find me ridemates to VESIT'\n"
                    f"• 'Check my diamond balance'\n"
                    f"• 'Show rewards marketplace'\n"
                    f"• 'How much CO₂ have I saved?'\n\n"
                    f"Slay the commute, split the bills 💅"
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
            friendly_msg = (
                f"Hey {update.effective_user.first_name}! 👋\n\n"
                "I'd love to help you with carpooling, but you need to be logged in first! \n\n"
                "Just type /start to get started - it only takes a few seconds! 🚀\n\n"
                "Once you're in, you can ask me things like:\n"
                "• 'Find me a ride to VESIT'\n"
                "• 'Show my diamond balance'\n"
                "• 'What rewards are available?'\n\n"
                "Ready to begin your eco-friendly journey? 🌱"
            )
            await update.message.reply_text(friendly_msg)
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
        """Quick search command with mode selection"""
        keyboard = [
            [InlineKeyboardButton("🚗 Carpooling", callback_data='search_carpool')],
            [InlineKeyboardButton("🛺 Auto Pooling", callback_data='search_auto')]
        ]
        reply_markup = InlineKeyboardMarkup(keyboard)
        
        await update.message.reply_text(
            "🔍 Find Ridemates\n\n"
            "Choose your ride mode:\n"
            "🚗 Carpooling - Slay the commute, split the bills 💅\n"
            "🛺 Auto Pooling - Squad up & save that drip money 🛺",
            reply_markup=reply_markup
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
    
    async def diamonds_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Show diamond balance"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        agent = user_sessions[user_id]['agent']
        response = agent._get_diamond_balance()
        await update.message.reply_text(response)
    
    async def marketplace_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Show rewards marketplace"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        await update.message.reply_text(
            "🎁 Rewards Marketplace\n\n"
            "Mock Products Available:\n"
            "🎧 Wireless Headphones - 450💎 (20% OFF)\n"
            "☕ Coffee Voucher - 150💎 (FREE)\n"
            "🎬 Movie Tickets - 300💎 (2 for 1)\n"
            "💪 Gym Membership - 800💎 (30% OFF)\n"
            "📚 Book Store Voucher - 400💎 (₹500 OFF)\n"
            "💆 Spa Package - 650💎 (25% OFF)\n\n"
            "Use the app to redeem! 📱"
        )
    
    async def trade_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Trade diamonds"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        await update.message.reply_text(
            "💱 Trade Diamonds\n\n"
            "Tell me who you want to send diamonds to:\n\n"
            "Example: 'Send 50 diamonds to sarah@techcorp.com'"
        )
    
    async def donate_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Donate to NGOs"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        await update.message.reply_text(
            "🌱 Donate to NGOs\n\n"
            "Available Organizations:\n"
            "🌳 Green Earth Foundation - 1 tree = 50💎\n"
            "🌫️ Clean Air Initiative - 1 sensor = 200💎\n"
            "☀️ Solar For All - 1 panel = 500💎\n"
            "🌊 Ocean Cleanup - 1kg plastic = 100💎\n\n"
            "Tell me how much you want to donate:\n"
            "Example: 'Donate 100 diamonds to Green Earth'"
        )
    
    async def payment_command(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        """Payment information"""
        user_id = update.effective_user.id
        
        if user_id not in user_sessions:
            await update.message.reply_text("Please login first using /start")
            return
        
        await update.message.reply_text(
            "💳 Payment Methods\n\n"
            "After your ride completes:\n"
            "💰 Wallet - Instant payment\n"
            "📱 QR Code - Scan to pay with UPI\n"
            "👤 Profile - View ridemate & copy UPI\n\n"
            "You'll earn Carbon Crystals (💎) after every payment!\n"
            "+150💎 per ride on average\n\n"
            "Use the app for seamless payment! 📱"
        )
    
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
🤖 **EcoPool AI Assistant** - Your Smart Travel Companion! 💅

🌟 **I understand natural language!** Just chat with me normally.

🎯 **Core Features:**
🔍 **Smart Ride Matching** - Find perfect ridemates
💬 **24-Hour Chat Rooms** - Connect with your ride group
💳 **Easy Payments** - QR code splitting & UPI integration
💎 **Carbon Crystals** - Earn diamonds for eco-rides
🎁 **Rewards System** - Redeem awesome prizes
💱 **Diamond Trading** - Trade with other users
🌱 **NGO Donations** - Support environmental causes
📊 **CO₂ Impact** - Track your planet-saving progress

💬 **Try these natural messages:**
• "Find me ridemates to VESIT tomorrow at 9 AM"
• "Show me my active carpools"
• "How many diamonds do I have?"
• "What rewards can I get for 100 diamonds?"
• "I want to donate to Green Earth Foundation"
• "How much CO₂ have I saved this month?"
• "Create a payment request for ₹50"

⚡ **Quick Commands:**
/search - 🔍 Find ridemates instantly
/mycarpools - 🚗 View your active rides
/diamonds - 💎 Check your balance
/marketplace - 🏪 Browse rewards
/trade - 💱 Trade diamonds
/donate - 🌱 Support NGOs
/payment - 💳 Payment options
/carbon - 📊 Your eco-impact
/logout - 👋 Sign out

🎉 **Pro tip:** The more you carpool, the more diamonds you earn!

Questions? Just ask me anything! 🚀
        """
        await update.message.reply_text(help_text, parse_mode='Markdown')
    
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
