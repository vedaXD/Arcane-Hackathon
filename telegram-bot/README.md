# 🤖 EcoPool Telegram Bot - Agentic AI Assistant

An intelligent, autonomous AI agent for carpooling that understands natural language and makes decisions on behalf of users.

## 🎯 What Makes This "Agentic"?

Unlike traditional chatbots that follow predefined flows, this bot is an **autonomous agent** that:

- **Understands Intent**: Uses GPT-4 to comprehend natural language
- **Makes Decisions**: Autonomously decides which tools/APIs to call
- **Multi-Step Planning**: Can chain multiple actions to complete complex tasks
- **Context Awareness**: Remembers conversation history and user preferences
- **Self-Correcting**: Handles errors and tries alternative approaches

### Example of Agentic Behavior:

**User:** "I need to go to VESIT tomorrow morning and want to save environment"

**Agent thinks:**
1. User wants to find a ride (search intent)
2. Destination is VESIT
3. Time is tomorrow morning (~9 AM)
4. User cares about environment (show CO₂ savings)

**Agent actions:**
1. Calls `GetPopularLocations` to confirm VESIT route
2. Calls `SearchCarpools` with inferred parameters
3. Presents results with CO₂ savings highlighted
4. Suggests which carpool saves most CO₂

## 🚀 Setup Instructions

### 1. Create Telegram Bot

1. Open Telegram and search for `@BotFather`
2. Send `/newbot` command
3. Follow prompts to name your bot (e.g., "EcoPool Assistant")
4. BotFather will give you a **BOT TOKEN** - save this!
5. Send `/setcommands` to BotFather and paste:

```
start - Start the bot and login
search - Search for carpools
offer - Offer your ride
mycarpools - View your carpools
rewards - Check your rewards
carbon - View CO₂ savings
help - Show help message
logout - Logout from bot
```

6. Send `/setdescription` and add:
```
AI-powered carpooling assistant. Find ridemates, offer rides, and track your environmental impact - all through natural conversation!
```

### 2. Install Dependencies

```powershell
cd "d:\Arcane Hax\Arcane-Hackathon\telegram-bot"

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Install requirements
pip install -r requirements.txt
```

### 3. Configure Environment

1. Copy `.env.example` to `.env`:
```powershell
Copy-Item .env.example .env
```

2. Edit `.env` and add your credentials:
```env
TELEGRAM_BOT_TOKEN=your_token_from_botfather
DJANGO_API_URL=http://localhost:8000/api
OPENAI_API_KEY=your_openai_api_key
BOT_USERNAME=your_bot_username
```

### 4. Get OpenAI API Key (For Agentic AI)

1. Go to https://platform.openai.com/
2. Sign up/login
3. Navigate to API Keys
4. Create new secret key
5. Copy and paste into `.env`

**Note:** You need GPT-4 access for best agentic behavior. GPT-3.5-turbo will work but with reduced intelligence.

### 5. Start Django Backend

Make sure your Django backend is running:
```powershell
cd "d:\Arcane Hax\Arcane-Hackathon\backend"
python manage.py runserver
```

### 6. Start Telegram Bot

```powershell
cd "d:\Arcane Hax\Arcane-Hackathon\telegram-bot"
.\venv\Scripts\Activate.ps1
python bot.py
```

You should see:
```
INFO - Starting bot...
INFO - Application started
```

## 📱 Using the Bot

### 1. Find Your Bot
Search for your bot username in Telegram (the one you set with BotFather)

### 2. Start Conversation
Send `/start` command

### 3. Login/Register
- Click "Login" button
- Send: `your.email@company.com yourpassword`

### 4. Natural Conversation Examples

Instead of rigid commands, just talk naturally:

**Finding Rides:**
```
"I need to go to VESIT tomorrow at 9 AM"
"Find me a carpool from Chembur to BKC"
"Any rides available for tomorrow morning?"
```

**Offering Rides:**
```
"I can offer my car tomorrow from Dadar to VESIT, 3 seats"
"Want to create a carpool for my route"
"I'm driving to BKC tomorrow at 8, anyone want to join?"
```

**Checking Stats:**
```
"How much CO₂ have I saved?"
"Show my environmental impact"
"What are my rewards?"
```

**Managing Carpools:**
```
"Show my upcoming rides"
"What carpools am I part of?"
"List my active carpools"
```

## 🧠 Agentic AI Architecture

```
User Message
    ↓
[LangChain Agent]
    ↓
[GPT-4 Reasoning] ← Decides which tools to use
    ↓
[Tool Selection]
    ├→ SearchCarpools
    ├→ OfferRide
    ├→ GetRewards
    ├→ GetCarbonStats
    └→ GetMyCarpools
    ↓
[Django API Calls]
    ↓
[Response Generation]
    ↓
User Receives Answer
```

### Key Components:

1. **LangChain Agent**: Orchestrates the AI's decision-making
2. **GPT-4 LLM**: Brain of the agent - understands and reasons
3. **Tool System**: Available actions the agent can take
4. **Memory**: Maintains conversation context
5. **API Client**: Communicates with Django backend

## 🔧 Customization

### Adding New Tools

Edit `agent.py` and add to `_create_tools()`:

```python
Tool(
    name="YourToolName",
    func=self._your_function,
    description="Clear description of what this tool does and when to use it"
)
```

### Changing AI Model

Edit `agent.py`:

```python
self.llm = ChatOpenAI(
    temperature=0.7,  # Lower = more deterministic
    model="gpt-3.5-turbo",  # or "gpt-4"
    api_key=config.OPENAI_API_KEY
)
```

### Adding Personality

Modify the agent's system prompt in `agent.py`:

```python
self.agent = initialize_agent(
    tools=self.tools,
    llm=self.llm,
    agent=AgentType.OPENAI_FUNCTIONS,
    memory=self.memory,
    agent_kwargs={
        "system_message": "You are a friendly carpooling assistant who cares deeply about environment..."
    }
)
```

## 🔐 Security Notes

- Never commit `.env` file (it's in `.gitignore`)
- Store bot token and API keys securely
- Use environment variables in production
- Implement rate limiting for API calls
- Validate all user inputs

## 🐛 Troubleshooting

**Bot doesn't respond:**
- Check if bot is running: `python bot.py`
- Verify token in `.env` is correct
- Check Django backend is running

**"I encountered an error":**
- Check Django API is accessible
- Verify API endpoints in `config.py`
- Check OpenAI API key is valid

**Agent makes wrong decisions:**
- Improve tool descriptions in `agent.py`
- Lower temperature for more deterministic responses
- Add more examples in tool descriptions

## 📊 Monitoring

Add logging to track agent decisions:

```python
import logging
logging.basicConfig(level=logging.INFO)
```

View agent reasoning process in console when `verbose=True` in agent initialization.

## 🚀 Deployment

### Deploy to Heroku:

1. Create `Procfile`:
```
worker: python bot.py
```

2. Deploy:
```powershell
git add .
git commit -m "Add telegram bot"
git push heroku main
```

3. Set environment variables:
```powershell
heroku config:set TELEGRAM_BOT_TOKEN=your_token
heroku config:set OPENAI_API_KEY=your_key
```

### Deploy to Railway:

1. Connect GitHub repository
2. Add environment variables in dashboard
3. Set start command: `python bot.py`

## 📝 License

MIT License - Feel free to modify and use!

---

**Built with ❤️ for sustainable commuting**
