<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Since you don't want login, we'll handle it differently
    // Instead of redirecting to login, we'll provide a default user
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    // If user is not logged in, set default values
    if (userRole == null) {
        userRole = "student"; // Default role
    }
    
    if (userFullName == null) {
        userFullName = "Guest Student"; // Default name
    }
    
    // Save to session for consistency
    session.setAttribute("userRole", userRole);
    session.setAttribute("userFullName", userFullName);
    
    String contextPath = request.getContextPath();
    if (contextPath == null || contextPath.isEmpty()) {
        contextPath = "";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Conversation Hub - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #FFF8E8 0%, #FFEED8 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #6B4F36;
            min-height: 100vh;
        }
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

        .home-link:hover {
            opacity: 0.7;
        }
        
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
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px 20px;
        }
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
        .message-header.ai {
            color: #D7923B;
        }
        .message-header.user {
            color: white;
        }
        .message-icon {
            font-size: 14px;
        }
        .message-content {
            line-height: 1.7;
        }
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
            transition: all 0.3s;
            color: #6B4F36;
        }
        .response-btn:hover {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
            transform: translateY(-2px);
        }
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
        .chat-input:focus {
            border-color: #D7923B;
        }
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
        .mood-tracker {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .mood-title {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .mood-options {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }
        .mood-option {
            width: 80px;
            height: 80px;
            background: #FFF3C8;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 3px solid transparent;
        }
        .mood-option:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .mood-option.active {
            border-color: #D7923B;
            background: #FFE9A9;
        }
        .mood-icon {
            font-size: 28px;
            margin-bottom: 8px;
        }
        .mood-label {
            font-size: 12px;
            font-weight: 600;
        }
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
        
        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
            .logo-section {
                width: 100%;
                justify-content: center;
            }
            .user-nav {
                width: 100%;
                justify-content: center;
            }
            .container {
                padding: 15px;
            }
            .chat-header {
                padding: 20px;
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            .chat-status {
                align-self: center;
            }
            .chat-messages {
                height: 400px;
                padding: 20px;
            }
            .message {
                max-width: 90%;
            }
            .quick-actions {
                padding: 20px;
                flex-direction: column;
            }
            .quick-action-btn {
                width: 100%;
            }
            .mood-options {
                flex-wrap: wrap;
            }
            .history-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="logo-section">
            <a href="<%= contextPath %>/dashboard" class="home-link">
                <div class="logo">
                    <i class="fas fa-home"></i>
                    SmileSpace
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

    <!-- Main Container -->
    <div class="container">
        <!-- Chat History Section -->
        <div class="chat-history">
            <div class="history-title">
                <i class="fas fa-history"></i> Recent Conversations
            </div>
            <div class="history-grid">
                <div class="history-item" onclick="loadConversation('stress_relief')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Today, 2:30 PM
                    </div>
                    <div class="history-preview">Stress relief breathing exercise - 5 cycles completed</div>
                </div>
                <div class="history-item" onclick="loadConversation('anxiety_talk')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Yesterday, 4:15 PM
                    </div>
                    <div class="history-preview">Anxiety management discussion - Coping strategies</div>
                </div>
                <div class="history-item" onclick="loadConversation('sleep_tips')">
                    <div class="history-date">
                        <i class="far fa-calendar"></i> Dec 2, 9:30 PM
                    </div>
                    <div class="history-preview">Sleep improvement techniques - Bedtime routine</div>
                </div>
            </div>
        </div>

        <!-- Current Chat -->
        <div class="chat-container">
            <!-- Chat Header -->
            <div class="chat-header">
                <div class="ai-avatar">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="chat-title">
                    <h1>Chat with Assistant</h1>
                    <p>Hi <%= userFullName %>, I'm here to support your mental wellbeing</p>
                </div>
                <div class="chat-status">
                    <i class="fas fa-circle" style="color:#4CAF50; font-size:10px;"></i> Available 24/7
                </div>
            </div>

            <!-- Chat Messages -->
            <div class="chat-messages" id="chatMessages">
                <!-- Initial messages -->
                <div class="message ai">
                    <div class="message-header ai">
                        <i class="fas fa-robot message-icon"></i>
                        AI Assistant
                    </div>
                    <div class="message-content">
                        Hello <%= userFullName %>! How are you feeling today?
                    </div>
                    <div class="response-options">
                        <button class="response-btn" onclick="sendQuickResponse('overwhelmed')">Overwhelmed 😔</button>
                        <button class="response-btn" onclick="sendQuickResponse('stressed')">Stressed 😞</button>
                        <button class="response-btn" onclick="sendQuickResponse('neutral')">Neutral 😐</button>
                        <button class="response-btn" onclick="sendQuickResponse('happy')">Happy 😊</button>
                    </div>
                </div>

                <div id="typingIndicator" class="typing-indicator">
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                    <div class="typing-dot"></div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <button class="quick-action-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-wind"></i> Breathing Exercise
                    <small>Calm anxiety with guided breathing</small>
                </button>
                <button class="quick-action-btn" onclick="startExercise('mindfulness')">
                    <i class="fas fa-brain"></i> Mindfulness Practice
                    <small>Stay present, reduce stress</small>
                </button>
                <button class="quick-action-btn" onclick="startExercise('gratitude')">
                    <i class="fas fa-heart"></i> Gratitude Journal
                    <small>Boost positivity and mood</small>
                </button>
                <button class="quick-action-btn" onclick="showCopingStrategies()">
                    <i class="fas fa-life-ring"></i> Coping Strategies
                    <small>Practical tools for tough moments</small>
                </button>
            </div>

            <!-- Chat Input -->
            <div class="chat-input-area">
                <div class="chat-input-wrapper">
                    <input type="text" 
                        class="chat-input" 
                        id="messageInput"
                        placeholder="Type your message here..."
                        onkeypress="handleKeyPress(event)">
                    <button class="chat-input-btn" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- End Chat Button -->
        <button class="end-chat-btn" onclick="endChat()">
            <i class="fas fa-sign-out-alt"></i> End Chat
        </button>
    </div>

    <script>
    // =============================================
    // CONFIGURATION
    // =============================================
    const API_ENDPOINT = '<%= contextPath %>/ai/chat';
    let conversationHistory = [];
    let currentMood = null;
    const userName = '<%= userFullName %>';

    // =============================================
    // CHAT FUNCTIONS
    // =============================================
    
    function addMessage(sender, content, isResponseOptions = false, options = null) {
        const chatMessages = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}`;
        
        const headerDiv = document.createElement('div');
        headerDiv.className = `message-header ${sender}`;
        headerDiv.innerHTML = sender === 'ai' 
            ? '<i class="fas fa-robot message-icon"></i> AI Assistant'
            : `<i class="fas fa-user message-icon"></i> ${userName}`;
        
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        
        // Use innerHTML for AI messages (they contain HTML formatting)
        // Use textContent for user messages (they are plain text)
        if (sender === 'ai' && content.includes('<')) {
            contentDiv.innerHTML = content;
        } else {
            // For plain text, convert line breaks to <br> tags
            contentDiv.innerHTML = content.replace(/\n/g, '<br>');
        }
        
        messageDiv.appendChild(headerDiv);
        messageDiv.appendChild(contentDiv);
        
        if (isResponseOptions && options) {
            const optionsDiv = document.createElement('div');
            optionsDiv.className = 'response-options';
            optionsDiv.innerHTML = options;
            messageDiv.appendChild(optionsDiv);
        }
        
        chatMessages.appendChild(messageDiv);
        
        // Add to history
        conversationHistory.push({
            sender: sender,
            content: content,
            timestamp: new Date().toISOString()
        });
        
        // Scroll to bottom
        chatMessages.scrollTop = chatMessages.scrollHeight;
        
        return messageDiv;
    }

    function showTyping() {
        const typingIndicator = document.getElementById('typingIndicator');
        typingIndicator.style.display = 'flex';
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function hideTyping() {
        const typingIndicator = document.getElementById('typingIndicator');
        typingIndicator.style.display = 'none';
    }

    // =============================================
    // API CALL FUNCTION
    // =============================================
    
    async function callAIApi(message) {
        try {
            const formData = new FormData();
            formData.append('message', message);
            
            const response = await fetch(API_ENDPOINT, {
                method: 'POST',
                body: formData
            });
            
            if (!response.ok) {
                throw new Error(`API error: ${response.status}`);
            }
            
            const data = await response.json();
            return data.response || "I'm here to support you. How can I help you today?";
            
        } catch (error) {
            console.error('API call failed:', error);
            // Fallback responses
            const fallbacks = [
                "I'm here to support you. How can I help you today?",
                "I understand. How can I support you right now?",
                "Thank you for sharing. How does that make you feel?",
                "I'm listening. Would you like to talk more about that?"
            ];
            return fallbacks[Math.floor(Math.random() * fallbacks.length)];
        }
    }

    async function sendMessage() {
        const input = document.getElementById('messageInput');
        const message = input.value.trim();
        
        if (message === '') return;
        
        // Add user message
        addMessage('user', message);
        input.value = '';
        
        // Show typing indicator
        showTyping();
        
        try {
            // Call the real API
            const aiResponse = await callAIApi(message);
            
            // Hide typing and show response
            hideTyping();
            const aiMessage = addMessage('ai', aiResponse);
            
            // Add relevant response options based on the message
            addSmartResponseOptions(message, aiMessage);
            
        } catch (error) {
            hideTyping();
            addMessage('ai', "I'm having trouble connecting. Please try again.");
        }
    }

    // =============================================
    // SMART RESPONSE OPTIONS
    // =============================================
    
    function addSmartResponseOptions(userMessage, parentElement) {
        const lowerMessage = userMessage.toLowerCase();
        let optionsHTML = '';
        
        // Check for emotional content
        if (lowerMessage.includes('stress') || lowerMessage.includes('anxious') || 
            lowerMessage.includes('overwhelm') || lowerMessage.includes('worry')) {
            optionsHTML = `
                <button class="response-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-wind"></i> Breathing Exercise
                </button>
                <button class="response-btn" onclick="showCopingStrategies()">
                    <i class="fas fa-life-ring"></i> Coping Strategies
                </button>
                <button class="response-btn" onclick="sendMessageDirect('Can you help me relax?')">
                    <i class="fas fa-spa"></i> Relaxation Tips
                </button>
            `;
        }
        else if (lowerMessage.includes('sad') || lowerMessage.includes('depress') || 
                 lowerMessage.includes('down') || lowerMessage.includes('unhappy')) {
            optionsHTML = `
                <button class="response-btn" onclick="startExercise('gratitude')">
                    <i class="fas fa-heart"></i> Gratitude Practice
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I need some encouragement')">
                    <i class="fas fa-hands-helping"></i> Encouragement
                </button>
                <button class="response-btn" onclick="sendMessageDirect('Tell me something positive')">
                    <i class="fas fa-sun"></i> Positive Thoughts
                </button>
            `;
        }
        else if (lowerMessage.includes('sleep') || lowerMessage.includes('tired') || 
                 lowerMessage.includes('insomnia')) {
            optionsHTML = `
                <button class="response-btn" onclick="sendMessageDirect('Give me sleep tips')">
                    <i class="fas fa-moon"></i> Sleep Tips
                </button>
                <button class="response-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-wind"></i> Relaxing Breath
                </button>
                <button class="response-btn" onclick="sendMessageDirect('Help me create a bedtime routine')">
                    <i class="fas fa-bed"></i> Bedtime Routine
                </button>
            `;
        }
        else if (lowerMessage.includes('exercise') || lowerMessage.includes('practice') || 
                 lowerMessage.includes('meditat') || lowerMessage.includes('mindful')) {
            optionsHTML = `
                <button class="response-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-wind"></i> Breathing
                </button>
                <button class="response-btn" onclick="startExercise('mindfulness')">
                    <i class="fas fa-brain"></i> Mindfulness
                </button>
                <button class="response-btn" onclick="startExercise('gratitude')">
                    <i class="fas fa-heart"></i> Gratitude
                </button>
            `;
        }
        
        if (optionsHTML) {
            const optionsDiv = document.createElement('div');
            optionsDiv.className = 'response-options';
            optionsDiv.innerHTML = optionsHTML;
            parentElement.appendChild(optionsDiv);
            
            // Scroll to show options
            setTimeout(() => {
                document.getElementById('chatMessages').scrollTop = document.getElementById('chatMessages').scrollHeight;
            }, 100);
        }
    }

    // =============================================
    // QUICK RESPONSES (These still use API)
    // =============================================
    
    async function sendQuickResponse(emotion) {
        let userMsg = '';
        switch(emotion) {
            case 'overwhelmed': userMsg = "I'm feeling overwhelmed with everything right now."; break;
            case 'stressed': userMsg = "I'm feeling stressed and anxious."; break;
            case 'neutral': userMsg = "I feel neutral - not particularly good or bad."; break;
            case 'happy': userMsg = "I feel happy and positive today!"; break;
            default: userMsg = "I want to talk about my feelings.";
        }
        
        // Add user message
        addMessage('user', userMsg);
        
        // Show typing indicator
        showTyping();
        
        try {
            // Call API with the emotion message
            const aiResponse = await callAIApi(userMsg);
            
            hideTyping();
            const aiMessage = addMessage('ai', aiResponse);
            
            // Add emotion-specific options
            setTimeout(() => {
                let emotionOptions = '';
                switch(emotion) {
                    case 'overwhelmed':
                    case 'stressed':
                        emotionOptions = `
                            <button class="response-btn" onclick="startExercise('breathing')">
                                <i class="fas fa-wind"></i> Breathing Exercise
                            </button>
                            <button class="response-btn" onclick="showCopingStrategies()">
                                <i class="fas fa-life-ring"></i> Coping Strategies
                            </button>
                            <button class="response-btn" onclick="sendMessageDirect('Help me break things down')">
                                <i class="fas fa-tasks"></i> Task Management
                            </button>
                        `;
                        break;
                    case 'sad':
                        emotionOptions = `
                            <button class="response-btn" onclick="startExercise('gratitude')">
                                <i class="fas fa-heart"></i> Gratitude Practice
                            </button>
                            <button class="response-btn" onclick="sendMessageDirect('I need comfort')">
                                <i class="fas fa-comfort"></i> Comforting Words
                            </button>
                            <button class="response-btn" onclick="sendMessageDirect('How can I feel better?')">
                                <i class="fas fa-smile"></i> Feel Better
                            </button>
                        `;
                        break;
                    case 'happy':
                        emotionOptions = `
                            <button class="response-btn" onclick="startExercise('gratitude')">
                                <i class="fas fa-heart"></i> Gratitude Journal
                            </button>
                            <button class="response-btn" onclick="sendMessageDirect('How can I maintain this feeling?')">
                                <i class="fas fa-lock"></i> Maintain Happiness
                            </button>
                            <button class="response-btn" onclick="sendMessageDirect('Share positive affirmations')">
                                <i class="fas fa-star"></i> Positive Affirmations
                            </button>
                        `;
                        break;
                }
                
                if (emotionOptions) {
                    const optionsDiv = document.createElement('div');
                    optionsDiv.className = 'response-options';
                    optionsDiv.innerHTML = emotionOptions;
                    aiMessage.appendChild(optionsDiv);
                }
            }, 500);
            
        } catch (error) {
            hideTyping();
            addMessage('ai', "I understand you're feeling this way. How can I support you right now?");
        }
    }

    function sendMessageDirect(text) {
        const input = document.getElementById('messageInput');
        input.value = text;
        sendMessage();
    }

    // =============================================
    // EXERCISE FUNCTIONS (Keep these as they are - they're local guides)
    // =============================================
    
    const exercises = {
        breathing: {
            title: "2-Minute Breathing Exercise",
            steps: [
                "Sit comfortably and close your eyes",
                "Breathe in slowly for 4 seconds",
                "Hold your breath for 2 seconds",
                "Breathe out slowly for 6 seconds",
                "Repeat for 5 cycles"
            ],
            followUp: "How do you feel now? Would you like to continue with another exercise?"
        },
        mindfulness: {
            title: "Mindfulness Practice",
            steps: [
                "Find a quiet place to sit",
                "Focus on your breathing",
                "Notice thoughts without judgment",
                "Return focus to breath",
                "Practice for 5 minutes"
            ],
            followUp: "Great job practicing mindfulness! How was your experience?"
        },
        gratitude: {
            title: "Gratitude Journal Practice",
            steps: [
                "Think of 3 things you're grateful for",
                "Write them down in detail",
                "Reflect on why they matter",
                "Notice how you feel",
                "Make this a daily habit"
            ],
            followUp: "Did writing help shift your perspective? Would you like to share one thing you're grateful for?"
        }
    };

    const copingStrategies = [
        "Practice deep breathing - Inhale 4s, hold 4s, exhale 6s",
        "Take a short walk - Even 5 minutes can help clear your mind",
        "Write down your thoughts - Journaling can provide clarity",
        "Talk to someone - Sharing helps reduce the burden",
        "Listen to calming music - Nature sounds or instrumental",
        "Practice progressive muscle relaxation - Tense and relax each muscle group"
    ];

    function startExercise(type) {
        const exercise = exercises[type];
        if (!exercise) return;
        
        const exerciseIntros = {
            breathing: "Breathing exercises can calm your nervous system in minutes. When stressed, focusing on your breath helps ground you in the present moment.",
            mindfulness: "Mindfulness helps you observe thoughts without judgment. Regular practice reduces stress and increases emotional resilience.",
            gratitude: "Gratitude journaling shifts focus from problems to positives. Studies show it can increase happiness by 25% over time."
        };
        
        // Build the HTML content properly
        let stepsHTML = '';
        exercise.steps.forEach((step, index) => {
            stepsHTML += `<li><span class="step-number">${index + 1}</span>${step}</li>`;
        });
        
        const intro = exerciseIntros[type] || "This exercise can help improve your mental wellbeing.";
        
        const response = `
            <strong>${exercise.title}</strong><br>
            ${intro}<br><br>
            <strong>Steps to follow:</strong>
            <div class="exercise-steps">
                <ol class="step-list">
                    ${stepsHTML}
                </ol>
            </div>
        `;
        
        addMessage('ai', response);
        
        const exerciseTips = {
            breathing: "💡 <strong>Tip:</strong> Place one hand on your chest and one on your belly. Feel your belly rise as you breathe in.",
            mindfulness: "💡 <strong>Tip:</strong> If your mind wanders, gently bring it back to your breath. This is normal and part of the practice.",
            gratitude: "💡 <strong>Tip:</strong> Be specific! Instead of 'I'm grateful for family,' try 'I'm grateful for how my sister made me laugh today.'"
        };
        
        setTimeout(() => {
            addMessage('ai', exerciseTips[type] || "Take your time and be gentle with yourself.");
        }, 300);
        
        setTimeout(() => {
            const optionsHTML = `
                <button class="response-btn" onclick="startExerciseTimer('${type}')">
                    <i class="fas fa-play"></i> Start Now
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I need more preparation time')">
                    <i class="fas fa-clock"></i> Not Ready Yet
                </button>
                <button class="response-btn" onclick="showCopingStrategies()">
                    <i class="fas fa-exchange-alt"></i> Different Exercise
                </button>
            `;
            addMessage('ai', "Ready to begin? Take a moment to get comfortable.", true, optionsHTML);
        }, 800);
    }

    function startExerciseTimer(type) {
        const exercise = exercises[type];
        if (!exercise) return;
        
        let timeLeft = 120;
        
        addMessage('ai', `Starting ${exercise.title} now. I'll guide you through it.`);
        
        const timerDiv = document.createElement('div');
        timerDiv.className = 'exercise-steps';
        timerDiv.innerHTML = `
            <strong>Exercise Timer:</strong><br>
            <div style="font-size: 24px; font-weight: bold; color: #D7923B; margin: 10px 0;" id="exerciseTimer">2:00</div>
            <div id="stepGuide">${exercise.steps[0]}</div>
        `;
        
        const aiMessage = document.createElement('div');
        aiMessage.className = 'message ai';
        aiMessage.innerHTML = `
            <div class="message-header ai">
                <i class="fas fa-robot message-icon"></i> AI Assistant
            </div>
            <div class="message-content"></div>
        `;
        
        aiMessage.querySelector('.message-content').appendChild(timerDiv);
        
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.appendChild(aiMessage);
        
        const timerInterval = setInterval(() => {
            timeLeft--;
            
            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                if (document.getElementById('exerciseTimer')) {
                    document.getElementById('exerciseTimer').textContent = "Complete!";
                }
                if (document.getElementById('stepGuide')) {
                    document.getElementById('stepGuide').textContent = "Great job!";
                }
                
                setTimeout(() => {
                    const optionsHTML = `
                        <button class="response-btn" onclick="sendMessageDirect('I feel better after the exercise')">
                            <i class="fas fa-smile"></i> Feeling Better
                        </button>
                        <button class="response-btn" onclick="sendMessageDirect('I want to try another exercise')">
                            <i class="fas fa-redo"></i> Try Another
                        </button>
                        <button class="response-btn" onclick="sendMessageDirect('Can we talk about how I feel now?')">
                            <i class="fas fa-comment"></i> Talk About It
                        </button>
                    `;
                    addMessage('ai', exercise.followUp, true, optionsHTML);
                }, 1000);
                return;
            }
            
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            if (document.getElementById('exerciseTimer')) {
                document.getElementById('exerciseTimer').textContent = 
                    `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
            }
            
            if (type === 'breathing' && document.getElementById('stepGuide')) {
                const cycleTime = 12;
                const cyclePosition = (120 - timeLeft) % cycleTime;
                
                if (cyclePosition < 4) {
                    document.getElementById('stepGuide').textContent = "Breathe IN...";
                } else if (cyclePosition < 6) {
                    document.getElementById('stepGuide').textContent = "HOLD...";
                } else {
                    document.getElementById('stepGuide').textContent = "Breathe OUT...";
                }
            }
            
        }, 1000);
    }

    function showCopingStrategies() {
        let strategiesHTML = '<ol class="step-list">';
        copingStrategies.forEach((strategy, index) => {
            strategiesHTML += `<li><span class="step-number">${index + 1}</span>${strategy}</li>`;
        });
        strategiesHTML += '</ol>';
        
        const response = `
            <strong>Coping Strategies for Tough Moments</strong><br>
            When emotions feel overwhelming, these evidence-based strategies can help:<br><br>
            <div class="exercise-steps">
                ${strategiesHTML}
            </div>
        `;
        
        addMessage('ai', response);
        
        setTimeout(() => {
            addMessage('ai', "💡 <strong>Pro Tip:</strong> Try 2-3 different strategies to see what works best for you. Everyone responds differently!");
        }, 300);
        
        setTimeout(() => {
            const optionsHTML = `
                <button class="response-btn" onclick="sendMessageDirect('I want to try the breathing strategy')">
                    <i class="fas fa-wind"></i> Breathing
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I want to try walking or exercise')">
                    <i class="fas fa-walking"></i> Movement
                </button>
                <button class="response-btn" onclick="sendMessageDirect('I want to try journaling')">
                    <i class="fas fa-book"></i> Journaling
                </button>
                <button class="response-btn" onclick="startExercise('breathing')">
                    <i class="fas fa-play-circle"></i> Guided Exercise
                </button>
            `;
            addMessage('ai', `Which strategy resonates with you most right now?`, true, optionsHTML);
        }, 800);
    }

    // =============================================
    // UTILITY FUNCTIONS
    // =============================================
    
    function handleKeyPress(event) {
        if (event.key === 'Enter') {
            sendMessage();
            event.preventDefault();
        }
    }

    function endChat() {
        if (confirm("Are you sure you want to end this chat? Your conversation will be saved.")) {
            localStorage.setItem('lastConversation', JSON.stringify({
                history: conversationHistory,
                mood: currentMood,
                timestamp: new Date().toISOString()
            }));
            
            alert("Chat ended. You can reload the page to start a new conversation.");
            
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.innerHTML = '';
            
            addMessage('ai', "Hello! How are you feeling today?", true, `
                <button class="response-btn" onclick="sendQuickResponse('overwhelmed')">Overwhelmed 😔</button>
                <button class="response-btn" onclick="sendQuickResponse('stressed')">Stressed 😞</button>
                <button class="response-btn" onclick="sendQuickResponse('neutral')">Neutral 😐</button>
                <button class="response-btn" onclick="sendQuickResponse('happy')">Happy 😊</button>
            `);
            
            conversationHistory = [];
        }
    }

    function loadConversation(conversationId) {
        if (confirm("Load this conversation? Your current chat will be cleared.")) {
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.innerHTML = '';
            
            let sampleMessages = [];
            
            switch(conversationId) {
                case 'stress_relief':
                    sampleMessages = [
                        { sender: 'ai', content: "Hello! How are you feeling today?" },
                        { sender: 'user', content: "A bit stressed about my work." },
                        { sender: 'ai', content: "I understand. Would you like to try a breathing exercise?" }
                    ];
                    break;
                case 'anxiety_talk':
                    sampleMessages = [
                        { sender: 'ai', content: "Welcome back! How have you been feeling?" },
                        { sender: 'user', content: "Some anxiety, but managing." },
                        { sender: 'ai', content: "Let's explore some coping strategies together." }
                    ];
                    break;
                case 'sleep_tips':
                    sampleMessages = [
                        { sender: 'ai', content: "Good to see you again! How has your sleep been?" },
                        { sender: 'user', content: "Better, thank you." },
                        { sender: 'ai', content: "Great! Would you like to refine your bedtime routine?" }
                    ];
                    break;
            }
            
            sampleMessages.forEach(msg => {
                addMessage(msg.sender, msg.content);
            });
            
            conversationHistory = sampleMessages;
        }
    }

    function goToLearningHub() {
        window.location.href = '<%= contextPath %>/ai/learn';
    }

    // =============================================
    // INITIALIZATION
    // =============================================
    
    window.addEventListener('load', function() {
        const input = document.getElementById('messageInput');
        if (input) {
            input.focus();
        }
        
        // Load any saved conversation
        const savedChat = localStorage.getItem('lastConversation');
        if (savedChat) {
            console.log("Found saved conversation from previous session");
        }
    });
    </script>
</body>
</html>