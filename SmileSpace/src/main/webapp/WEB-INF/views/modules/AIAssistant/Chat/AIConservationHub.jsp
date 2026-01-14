<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // User session handling
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    // Set default values if not logged in
    if (userRole == null) userRole = "student";
    if (userFullName == null) userFullName = "Guest Student";
    
    session.setAttribute("userRole", userRole);
    session.setAttribute("userFullName", userFullName);
    
    String contextPath = request.getContextPath();
    if (contextPath == null || contextPath.isEmpty()) contextPath = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Conversation Hub - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* ========== RESET & BASE STYLES ========== */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            background: linear-gradient(135deg, #FFF8E8 0%, #FFEED8 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #6B4F36;
            min-height: 100vh;
        }
        
        /* ========== HEADER STYLES ========== */
        .header {
            background-color: #FFF3C8;
            padding: 15px 40px;
            border-bottom: 2px solid #E8D9B5;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .home-link {
            text-decoration: none;
            color: inherit;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: opacity 0.2s;
        }
        
        .home-link:hover { opacity: 0.7; }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .logo-section {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .page-title {
            font-size: 24px;
            color: #6B4F36;
            font-weight: 600;
            position: relative;
            padding-left: 20px;
        }
        
        .page-title:before {
            content: "";
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 24px;
            background: #D7923B;
            border-radius: 2px;
        }
        
        .user-nav {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .nav-btn {
            background: #FFF3C8;
            color: #6B4F36;
            padding: 10px 25px;
            border-radius: 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            border: 2px solid transparent;
        }
        
        .nav-btn:hover {
            background: #D7923B;
            color: white;
            transform: translateY(-2px);
        }
        
        .nav-btn.secondary {
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
        }
        
        .nav-btn.secondary:hover {
            background: #FFF3C8;
            color: #6B4F36;
        }
        
        /* ========== MAIN CONTAINER ========== */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px 20px;
        }
        
        /* ========== CHAT HISTORY ========== */
        .chat-history {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        
        .history-title {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .history-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .history-item {
            background: #FAF5ED;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #E8D4B9;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .history-item:hover {
            transform: translateY(-5px);
            border-color: #D7923B;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .history-date {
            color: #8B7355;
            font-size: 13px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .history-preview {
            color: #6B4F36;
            line-height: 1.5;
            font-size: 15px;
        }
        
        /* ========== CHAT CONTAINER ========== */
        .chat-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 40px;
        }
        
        .chat-header {
            background: linear-gradient(135deg, #D7923B 0%, #CF8224 100%);
            color: white;
            padding: 25px 30px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .ai-avatar {
            width: 70px;
            height: 70px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: #D7923B;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .chat-title {
            flex: 1;
        }
        
        .chat-title h1 {
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .chat-title p {
            opacity: 0.9;
            font-size: 16px;
        }
        
        .chat-status {
            background: rgba(255,255,255,0.2);
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        /* ========== CHAT MESSAGES ========== */
        .chat-messages {
            height: 500px;
            padding: 30px;
            overflow-y: auto;
            background: #FAF5ED;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .message {
            max-width: 75%;
            padding: 18px;
            border-radius: 18px;
            line-height: 1.6;
            position: relative;
            animation: fadeIn 0.3s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .message.ai {
            background: white;
            align-self: flex-start;
            border-bottom-left-radius: 5px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            border-left: 4px solid #D7923B;
        }
        
        .message.user {
            background: linear-gradient(135deg, #D7923B 0%, #CF8224 100%);
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 5px;
            box-shadow: 0 3px 10px rgba(215, 146, 59, 0.2);
        }
        
        .message-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .message-header.ai { color: #D7923B; }
        .message-header.user { color: white; }
        
        .message-icon { font-size: 14px; }
        .message-content { line-height: 1.7; }
        
        /* ========== RESPONSE OPTIONS ========== */
        .response-options {
            display: flex;
            gap: 15px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        
        .response-btn {
            padding: 10px 20px;
            background: white;
            border: 2px solid #E8D4B9;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #6B4F36;
            transition: all 0.3s;
        }
        
        .response-btn:hover {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
            transform: translateY(-2px);
        }
        
        /* ========== QUICK ACTIONS ========== */
        .quick-actions {
            display: flex;
            gap: 15px;
            padding: 0 30px 25px;
            background: white;
        }
        
        .quick-action-btn {
            padding: 12px 25px;
            background: #FFF3C8;
            border: 2px solid #FFE9A9;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #6B4F36;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            flex-direction: column;
            align-items: flex-start;
            min-width: 200px;
            flex: 1;
        }
        
        .quick-action-btn:hover {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
        }
        
        .quick-action-btn small {
            font-size: 11px;
            opacity: 0.8;
            margin-top: 5px;
        }
        
        /* ========== CHAT INPUT ========== */
        .chat-input-area {
            padding: 25px 30px;
            background: white;
            border-top: 1px solid #E8D4B9;
            display: flex;
            gap: 15px;
        }
        
        .chat-input-wrapper {
            flex: 1;
            position: relative;
        }
        
        .chat-input {
            width: 100%;
            padding: 16px 20px;
            padding-right: 50px;
            border: 2px solid #E8D4B9;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        
        .chat-input:focus { border-color: #D7923B; }
        
        .chat-input-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: #D7923B;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        .chat-input-btn:hover {
            background: #CF8224;
            transform: translateY(-50%) scale(1.05);
        }
        
        /* ========== TYPING INDICATOR ========== */
        .typing-indicator {
            display: none;
            align-items: center;
            gap: 8px;
            padding: 15px;
            background: white;
            border-radius: 18px;
            border-bottom-left-radius: 5px;
            align-self: flex-start;
            max-width: 120px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }
        
        .typing-dot {
            width: 8px;
            height: 8px;
            background: #D7923B;
            border-radius: 50%;
            animation: typingBounce 1.5s infinite;
        }
        
        .typing-dot:nth-child(2) { animation-delay: 0.2s; }
        .typing-dot:nth-child(3) { animation-delay: 0.4s; }
        
        @keyframes typingBounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }
        
        /* ========== END CHAT BUTTON ========== */
        .end-chat-btn {
            display: block;
            width: 200px;
            margin: 40px auto;
            padding: 15px 30px;
            background: #FFF3C8;
            color: #6B4F36;
            border: 2px solid #D7923B;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s;
        }
        
        .end-chat-btn:hover {
            background: #D7923B;
            color: white;
            transform: translateY(-2px);
        }
        
        /* ========== SPECIAL FORMATTING ========== */
        .exercise-steps {
            background: #F0F8FF;
            border-left: 4px solid #4A90E2;
            padding: 15px;
            margin: 15px 0;
            border-radius: 0 8px 8px 0;
        }
        
        .step-list {
            list-style: none;
            padding-left: 0;
        }
        
        .step-list li {
            padding: 8px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .step-number {
            width: 28px;
            height: 28px;
            background: #4A90E2;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
        }
        
        /* ========== RESPONSIVE DESIGN ========== */
        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
            
            .logo-section,
            .user-nav {
                width: 100%;
                justify-content: center;
            }
            
            .container { padding: 15px; }
            
            .chat-header {
                padding: 20px;
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            
            .chat-status { align-self: center; }
            
            .chat-messages {
                height: 400px;
                padding: 20px;
            }
            
            .message { max-width: 90%; }
            
            .quick-actions {
                padding: 20px;
                flex-direction: column;
            }
            
            .quick-action-btn { width: 100%; }
            
            .history-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <div class="header">
        <div class="logo-section">
            <a href="<%= contextPath %>/dashboard" class="home-link">
                <div class="logo">
                    <i class="fas fa-home"></i> SmileSpace
                </div>
            </a>
            <div class="page-title">AI Conversation Hub</div>
        </div>
        <div class="user-nav">
            <a href="<%= contextPath %>/dashboard" class="nav-btn secondary">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="<%= contextPath %>/ai/learn" class="nav-btn">
                <i class="fas fa-graduation-cap"></i> Learning Hub
            </a>
        </div>
    </div>

    <!-- Main Content Container -->
    <div class="container">
        <!-- Recent Conversations -->
        <div class="chat-history">
            <div class="history-title">
                <i class="fas fa-history"></i> Recent Conversations
            </div>
            <div class="history-grid">
                <div class="history-item" onclick="ChatManager.loadConversation('stress_relief')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Today, 2:30 PM
                    </div>
                    <div class="history-preview">Stress relief breathing exercise - 5 cycles completed</div>
                </div>
                <div class="history-item" onclick="ChatManager.loadConversation('anxiety_talk')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Yesterday, 4:15 PM
                    </div>
                    <div class="history-preview">Anxiety management discussion - Coping strategies</div>
                </div>
                <div class="history-item" onclick="ChatManager.loadConversation('sleep_tips')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Dec 2, 9:30 PM
                    </div>
                    <div class="history-preview">Sleep improvement techniques - Bedtime routine</div>
                </div>
            </div>
        </div>

        <!-- Chat Interface -->
        <div class="chat-container">
            <!-- Chat Header -->
            <div class="chat-header">
                <div class="ai-avatar"><i class="fas fa-robot"></i></div>
                <div class="chat-title">
                    <h1>Chat with Assistant</h1>
                    <p>Hi <%= userFullName %>, I'm here to support your mental wellbeing</p>
                </div>
                <div class="chat-status">
                    <i class="fas fa-circle" style="color:#4CAF50; font-size:10px;"></i> Available 24/7
                </div>
            </div>

            <!-- Chat Messages Area -->
            <div class="chat-messages" id="chatMessages">
                <!-- Initial Message -->
                <div class="message ai">
                    <div class="message-header ai">
                        <i class="fas fa-robot message-icon"></i> AI Assistant
                    </div>
                    <div class="message-content">
                        Hello <%= userFullName %>! How are you feeling today?
                    </div>
                    <div class="response-options">
                        <button class="response-btn" onclick="ChatManager.sendQuickResponse('overwhelmed')">Overwhelmed 😔</button>
                        <button class="response-btn" onclick="ChatManager.sendQuickResponse('stressed')">Stressed 😞</button>
                        <button class="response-btn" onclick="ChatManager.sendQuickResponse('neutral')">Neutral 😐</button>
                        <button class="response-btn" onclick="ChatManager.sendQuickResponse('happy')">Happy 😊</button>
                    </div>
                </div>

                <!-- Typing Indicator -->
                <div id="typingIndicator" class="typing-indicator">
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                </div>
            </div>

            <!-- Quick Action Buttons -->
            <div class="quick-actions">
                <button class="quick-action-btn" onclick="ChatManager.startExercise('breathing')">
                    <i class="fas fa-wind"></i> Breathing Exercise
                    <small>Calm anxiety with guided breathing</small>
                </button>
                <button class="quick-action-btn" onclick="ChatManager.startExercise('mindfulness')">
                    <i class="fas fa-brain"></i> Mindfulness Practice
                    <small>Stay present, reduce stress</small>
                </button>
                <button class="quick-action-btn" onclick="ChatManager.startExercise('gratitude')">
                    <i class="fas fa-heart"></i> Gratitude Journal
                    <small>Boost positivity and mood</small>
                </button>
                <button class="quick-action-btn" onclick="ChatManager.showCopingStrategies()">
                    <i class="fas fa-life-ring"></i> Coping Strategies
                    <small>Practical tools for tough moments</small>
                </button>
            </div>

            <!-- Message Input -->
            <div class="chat-input-area">
                <div class="chat-input-wrapper">
                    <input type="text" 
                           class="chat-input" 
                           id="messageInput"
                           placeholder="Type your message here..."
                           onkeypress="ChatManager.handleKeyPress(event)">
                    <button class="chat-input-btn" onclick="ChatManager.sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- End Chat Button -->
        <button class="end-chat-btn" onclick="ChatManager.endChat()">
            <i class="fas fa-sign-out-alt"></i> End Chat
        </button>
    </div>

    <script>
    // =============================================
    // CHAT MANAGER - Main Application Object
    // =============================================
    const ChatManager = {
        // Configuration - use JSP variables directly
        API_ENDPOINT: '<%= contextPath %>/chat/send',
        userName: '<%= userFullName %>',  // JSP variable injected here
        conversationHistory: [],
        currentMood: null,
        
        // ========== MESSAGE MANAGEMENT ==========
        addMessage: function(sender, content) {
            const chatMessages = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = 'message ' + sender;
            
            const headerDiv = document.createElement('div');
            headerDiv.className = 'message-header ' + sender;
            headerDiv.innerHTML = sender === 'ai' 
                ? '<i class="fas fa-robot message-icon"></i> AI Assistant'
                : '<i class="fas fa-user message-icon"></i> ' + this.userName;
            
            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            contentDiv.innerHTML = content.replace(/\n/g, '<br>');
            
            messageDiv.appendChild(headerDiv);
            messageDiv.appendChild(contentDiv);
            chatMessages.appendChild(messageDiv);
            
            // Add to history
            this.conversationHistory.push({
                sender: sender,
                content: content,
                timestamp: new Date().toISOString()
            });
            
            // Scroll to bottom with smooth animation
            setTimeout(() => {
                chatMessages.scrollTo({
                    top: chatMessages.scrollHeight,
                    behavior: 'smooth'
                });
            }, 100);
            
            return messageDiv;
        },
        
        showTyping: function() {
            const typingIndicator = document.getElementById('typingIndicator');
            typingIndicator.style.display = 'flex';
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.scrollTop = chatMessages.scrollHeight;
        },
        
        hideTyping: function() {
            const typingIndicator = document.getElementById('typingIndicator');
            typingIndicator.style.display = 'none';
        },
        
        // ========== API COMMUNICATION ==========
        callAIApi: async function(message) {
            try {
                console.log("Sending message to API:", message);
                
                const response = await fetch(this.API_ENDPOINT, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ message: message })
                });
                
                if (!response.ok) {
                    throw new Error('API error: ' + response.status);
                }
                
                const data = await response.json();
                console.log("API Response received:", data);
                return data.message || "I'm here to support you. How can I help you today?";
                
            } catch (error) {
                console.error('API call failed:', error);
                throw error;
            }
        },
        
        // ========== MESSAGE SENDING ==========
        sendMessage: async function() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            
            if (!message) return;
            
            this.addMessage('user', message);
            input.value = '';
            
            this.showTyping();
            
            try {
                const aiResponse = await this.callAIApi(message);
                this.hideTyping();
                this.addMessage('ai', aiResponse);
            } catch (error) {
                this.hideTyping();
                this.addMessage('ai', "I'm having trouble connecting to the AI service. Please try again.");
            }
        },
        
        sendMessageDirect: function(text) {
            const input = document.getElementById('messageInput');
            input.value = text;
            this.sendMessage();
        },
        
        // ========== QUICK RESPONSES ==========
        sendQuickResponse: async function(emotion) {
            const responses = {
                'overwhelmed': "I'm feeling overwhelmed with everything right now.",
                'stressed': "I'm feeling stressed and anxious.",
                'neutral': "I feel neutral - not particularly good or bad.",
                'happy': "I feel happy and positive today!"
            };
            
            const userMsg = responses[emotion] || "I want to talk about my feelings.";
            
            this.addMessage('user', userMsg);
            this.showTyping();
            
            try {
                const aiResponse = await this.callAIApi(userMsg);
                this.hideTyping();
                this.addMessage('ai', aiResponse);
            } catch (error) {
                this.hideTyping();
                this.addMessage('ai', "I understand you're feeling this way. How can I support you right now?");
            }
        },
        
        // ========== EXERCISE & COPING FUNCTIONS ==========
        startExercise: function(type) {
            const exercises = {
                'breathing': "Can you guide me through a breathing exercise to help me calm down?",
                'mindfulness': "I'd like to practice mindfulness. Can you help me with that?",
                'gratitude': "I want to start a gratitude practice. Can you help me with that?"
            };
            
            const message = exercises[type] || "I'd like to try an exercise to help me feel better.";
            this.sendMessageDirect(message);
        },
        
        showCopingStrategies: function() {
            this.sendMessageDirect("Can you share some coping strategies for dealing with difficult emotions?");
        },
        
        // ========== UTILITY FUNCTIONS ==========
        handleKeyPress: function(event) {
            if (event.key === 'Enter') {
                this.sendMessage();
                event.preventDefault();
            }
        },
        
        endChat: function() {
            if (confirm("Are you sure you want to end this chat? Your conversation will be saved.")) {
                // Save to localStorage
                localStorage.setItem('lastConversation', JSON.stringify({
                    history: this.conversationHistory,
                    mood: this.currentMood,
                    timestamp: new Date().toISOString()
                }));
                
                alert("Chat ended. You can reload the page to start a new conversation.");
                
                // Clear and reset chat
                const chatMessages = document.getElementById('chatMessages');
                chatMessages.innerHTML = '';
                this.conversationHistory = [];
                
                // Add initial message - FIXED: using string concatenation instead of template literals
                const initialMessage = document.createElement('div');
                initialMessage.className = 'message ai';
                
                const headerDiv = document.createElement('div');
                headerDiv.className = 'message-header ai';
                headerDiv.innerHTML = '<i class="fas fa-robot message-icon"></i> AI Assistant';
                
                const contentDiv = document.createElement('div');
                contentDiv.className = 'message-content';
                contentDiv.textContent = 'Hello ' + this.userName + '! How are you feeling today?';
                
                const optionsDiv = document.createElement('div');
                optionsDiv.className = 'response-options';
                optionsDiv.innerHTML = '<button class="response-btn" onclick="ChatManager.sendQuickResponse(\'overwhelmed\')">Overwhelmed 😔</button>' +
                                       '<button class="response-btn" onclick="ChatManager.sendQuickResponse(\'stressed\')">Stressed 😞</button>' +
                                       '<button class="response-btn" onclick="ChatManager.sendQuickResponse(\'neutral\')">Neutral 😐</button>' +
                                       '<button class="response-btn" onclick="ChatManager.sendQuickResponse(\'happy\')">Happy 😊</button>';
                
                initialMessage.appendChild(headerDiv);
                initialMessage.appendChild(contentDiv);
                initialMessage.appendChild(optionsDiv);
                chatMessages.appendChild(initialMessage);
            }
        },
        
        loadConversation: function(conversationId) {
            if (confirm("Load this conversation? Your current chat will be cleared.")) {
                const chatMessages = document.getElementById('chatMessages');
                chatMessages.innerHTML = '';
                this.conversationHistory = [];
                
                const conversations = {
                    'stress_relief': [
                        { sender: 'ai', content: "Hello! How are you feeling today?" },
                        { sender: 'user', content: "A bit stressed about my work." },
                        { sender: 'ai', content: "I understand. Would you like to try a breathing exercise?" }
                    ],
                    'anxiety_talk': [
                        { sender: 'ai', content: "Welcome back! How have you been feeling?" },
                        { sender: 'user', content: "Some anxiety, but managing." },
                        { sender: 'ai', content: "Let's explore some coping strategies together." }
                    ],
                    'sleep_tips': [
                        { sender: 'ai', content: "Good to see you again! How has your sleep been?" },
                        { sender: 'user', content: "Better, thank you." },
                        { sender: 'ai', content: "Great! Would you like to refine your bedtime routine?" }
                    ]
                };
                
                const messages = conversations[conversationId] || [];
                messages.forEach(msg => this.addMessage(msg.sender, msg.content));
            }
        },
        
        // ========== INITIALIZATION ==========
        init: function() {
            const input = document.getElementById('messageInput');
            if (input) input.focus();
            
            // Load saved conversation if exists
            const savedChat = localStorage.getItem('lastConversation');
            if (savedChat) {
                console.log("Loaded saved conversation from previous session");
            }
            
            // Add event listeners for better UX
            input.addEventListener('input', function() {
                if (this.value.trim()) {
                    this.style.borderColor = '#D7923B';
                } else {
                    this.style.borderColor = '#E8D4B9';
                }
            });
        }
    };
    
    // Initialize when page loads
    window.addEventListener('DOMContentLoaded', function() {
        ChatManager.init();
    });
    </script>
</body>
</html>