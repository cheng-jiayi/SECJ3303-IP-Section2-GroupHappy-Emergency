<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get user information if available (for displaying name)
    String userFullName = (String) session.getAttribute("userFullName");
    if (userFullName == null) {
        userFullName = "Guest Student";
    }
    
    String contextPath = request.getContextPath();
    if (contextPath == null || contextPath.isEmpty()) {
        contextPath = "";
    }
    
    // Get module and topic parameters
    String module = (String) request.getAttribute("module");
    if (module == null) {
        module = "stress";
    }
    
    String topicParam = (String) request.getAttribute("topic");
    int currentTopic = 1;
    boolean isComplete = false;
    
    if (topicParam != null) {
        if (topicParam.equals("complete")) {
            isComplete = true;
        } else {
            try {
                currentTopic = Integer.parseInt(topicParam);
            } catch (NumberFormatException e) {
                currentTopic = 1;
            }
        }
    }
    
    // Get attributes from model
    String topicTitle = (String) request.getAttribute("topicTitle");
    String aiMessage = (String) request.getAttribute("aiMessage");
    String mainContent = (String) request.getAttribute("mainContent");
    String exampleContent = (String) request.getAttribute("exampleContent");
    
    // If attributes are null, use defaults
    if (topicTitle == null) {
        String[] topicTitles = {
            "Understanding Stress",
            "Coping Strategies",
            "Maintaining Long-Term Stress Management"
        };
        topicTitle = topicTitles[currentTopic-1];
    }
    
    if (aiMessage == null) {
        String[] aiMessages = {
            "Let's talk about stress management today. Stress is a normal response to challenges, but too much can affect your health.",
            "Now that you understand stress, let's explore practical ways to cope with it effectively.",
            "Great! Let's discuss maintaining a healthy mindset and preventing burnout over the long term."
        };
        aiMessage = aiMessages[currentTopic-1];
    }
    
    if (mainContent == null) {
        String[] mainContents = {
            "Stress triggers physical reactions like faster heartbeat and tense muscles. Understanding these reactions helps you manage them effectively.<br><br>Here's a quick tip: Take 5 deep breaths whenever you feel overwhelmed — it can calm your mind instantly.",
            "One common method is time management. Breaking tasks into smaller steps reduces overwhelm and boosts focus.<br><br>Another tip: Physical activity like a 10-minute walk can relieve tension and improve your mood.",
            "Regular sleep, balanced diet, and mindfulness practices help keep stress levels manageable.<br><br>Try scheduling a weekly self-care routine: start meditation, journaling, or talking with a friend."
        };
        mainContent = mainContents[currentTopic-1];
    }
    
    if (exampleContent == null) {
        String[] exampleContents = {
            "When you feel overwhelmed with work, stop and take 5 deep breaths. This simple technique can help calm your nervous system and clear your mind.",
            "Imagine having multiple assignments. Try creating a checklist and tackling one task at a time.",
            "Managing Stress in Daily Life: Learn how to identify sources of everyday stress, and build healthy habits.<br><br>Time Management to Reduce Stress: Understand how effective time management can lower stress levels."
        };
        exampleContent = exampleContents[currentTopic-1];
    }
    
    // Calculate progress width
    int widthPercent = 0;
    if (!isComplete) {
        widthPercent = (currentTopic * 100) / 3;
    } else {
        widthPercent = 100;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Learning Mode - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            color: #6B4F36;
            min-height: 100vh;
        }
        .header {
            background: #FFF3C8;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(107, 79, 54, 0.1);
        }
        .logo h1 {
            color: #D7923B;
            font-size: 32px;
        }
        .nav-buttons {
            display: flex;
            gap: 15px;
        }
        .nav-btn {
            background: #D7923B;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: background 0.3s;
            border: none;
            cursor: pointer;
        }
        .nav-btn:hover {
            background: #CF8224;
        }
        .nav-btn.secondary {
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
        }
        .nav-btn.secondary:hover {
            background: #FFF3C8;
        }
        .learn-container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
            min-height: calc(100vh - 100px);
        }
        .learning-header {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .learning-header h2 {
            color: #D7923B;
            font-size: 28px;
            margin-bottom: 5px;
        }
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #E8D4B9;
            border-radius: 4px;
            margin: 15px 0;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: #D7923B;
            border-radius: 4px;
            transition: width 0.5s;
        }
        .topic-indicator {
            display: flex;
            justify-content: space-between;
            color: #8B7355;
            font-size: 14px;
        }
        .topic-nav-dots {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 20px 0;
        }
        .topic-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #E8D4B9;
            cursor: pointer;
        }
        .topic-dot.active {
            background: #D7923B;
        }
        
        /* Chat Section */
        .chat-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chat-header {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .chat-avatar {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #D7923B, #CF8224);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 28px;
        }
        
        .chat-info h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 5px;
        }
        
        .chat-info p {
            color: #8B7355;
            font-size: 14px;
        }
        
        .ai-message-box {
            background: linear-gradient(135deg, #FFF3C8, #FFE9A9);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border-left: 5px solid #D7923B;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .ai-message-box .ai-avatar {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .ai-avatar-icon {
            width: 50px;
            height: 50px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }
        
        .ai-name {
            font-weight: bold;
            color: #D7923B;
            font-size: 18px;
        }
        
        .ai-message {
            color: #6B4F36;
            font-size: 16px;
            line-height: 1.6;
        }
        
        /* Content Section */
        .content-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .content-box {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .content-box h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #FFF3C8;
        }
        
        .content-text {
            color: #6B4F36;
            line-height: 1.8;
            font-size: 16px;
        }
        
        .tip-box {
            background: #E8F4FD;
            border-left: 4px solid #4A90E2;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 10px 10px 0;
        }
        
        .tip-title {
            color: #4A90E2;
            font-weight: bold;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .example-box {
            background: #F0F8F0;
            border: 2px dashed #4CAF50;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }
        
        .example-title {
            color: #4CAF50;
            font-weight: bold;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        /* Chat Input Area */
        .chat-input-area {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .input-wrapper {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .chat-input {
            flex: 1;
            padding: 12px 20px;
            border: 2px solid #E8D4B9;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        
        .chat-input:focus {
            border-color: #D7923B;
        }
        
        .send-button {
            padding: 12px 25px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .send-button:hover {
            background: #CF8224;
            transform: translateY(-2px);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 12px 20px;
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .action-btn:hover {
            background: #D7923B;
            color: white;
        }
        
        .action-btn.next {
            background: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        
        .action-btn.next:hover {
            background: #45a049;
            border-color: #45a049;
        }
        
        /* Chat Messages Container */
        .chat-messages-container {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 20px;
            padding: 15px;
            background: #f9f9f9;
            border-radius: 10px;
            border: 1px solid #E8D4B9;
        }
        
        .message {
            margin-bottom: 15px;
            padding: 12px 15px;
            border-radius: 10px;
            max-width: 80%;
        }
        
        .message.ai {
            background: white;
            border-left: 4px solid #D7923B;
            margin-right: auto;
        }
        
        .message.user {
            background: #D7923B;
            color: white;
            margin-left: auto;
        }
        
        .message-header {
            font-weight: bold;
            margin-bottom: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .message-header.ai {
            color: #D7923B;
        }
        
        .message-header.user {
            color: white;
        }
        
        .message-content {
            line-height: 1.6;
        }
        
        .message-icon {
            font-size: 14px;
        }
        
        .tip-message {
            background: #E8F4FD;
            border-left: 4px solid #4A90E2;
            padding: 12px 15px;
            margin: 8px 0;
            border-radius: 0 8px 8px 0;
        }
        
        .example-message {
            background: #F0F8F0;
            border: 1px solid #4CAF50;
            padding: 12px 15px;
            margin: 8px 0;
            border-radius: 8px;
        }
        
        .message-empty-state {
            text-align: center;
            color: #8B7355;
            font-style: italic;
            padding: 30px;
            font-size: 14px;
        }
        
        /* Navigation Buttons */
        .navigation-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #E8D4B9;
        }
        
        /* Module Complete */
        .module-complete {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-top: 30px;
        }
        
        .module-complete h2 {
            color: #4CAF50;
            font-size: 32px;
            margin-bottom: 20px;
        }
        
        .module-complete p {
            color: #6B4F36;
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .completion-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }
        
        .resources-section {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 25px;
            margin-top: 30px;
        }
        
        .resources-section h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .resource-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .resource-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .resource-item h4 {
            color: #CF8224;
            margin-bottom: 10px;
        }
        
        .resource-item p {
            color: #8B7355;
            font-size: 14px;
            line-height: 1.5;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .learn-container {
                padding: 20px;
            }
            
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
            
            .nav-buttons {
                width: 100%;
                justify-content: center;
            }
            
            .action-buttons {
                justify-content: center;
            }
            
            .action-btn {
                flex: 1;
                min-width: 120px;
                justify-content: center;
            }
            
            .navigation-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .resource-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="logo">
            <h1>SmileSpace</h1>
        </div>
        <div class="nav-buttons">
            <a href="<%= contextPath %>/ai/learn" class="nav-btn secondary">
                <i class="fas fa-home"></i> Learning Hub
            </a>
            <a href="<%= contextPath %>/dashboard" class="nav-btn">
                <i class="fas fa-arrow-left"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="learn-container">
        <% if (!isComplete) { %>
            <!-- Learning Mode Header -->
            <div class="learning-header">
                <h2>Learning Mode</h2>
                <div class="topic-indicator">
                    <span>Topic <%= currentTopic %> of 3 : <%= topicTitle %></span>
                    <span>Stress Module</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: <%= widthPercent %>%"></div>
                </div>
                <div class="topic-nav-dots">
                    <% for (int i = 1; i <= 3; i++) { %>
                        <div class="topic-dot <%= (i == currentTopic) ? "active" : "" %>" 
                            onclick="location.href='<%= contextPath %>/ai/learn/module?module=<%= module %>&topic=<%= i %>'"></div>
                    <% } %>
                </div>
            </div>

            <!-- Chat Section -->
            <div class="chat-section">
                <!-- AI Welcome Message -->
                <div class="ai-message-box">
                    <div class="ai-avatar">
                        <div class="ai-avatar-icon">
                            <i class="fas fa-robot"></i>
                        </div>
                        <div class="ai-name">AI Assistant</div>
                    </div>
                    <div class="ai-message">
                        Hi <%= userFullName %>! <%= aiMessage %> What would you like to know about <%= topicTitle.toLowerCase() %>?
                        <br><br>
                        <strong>Try asking:</strong>
                        <ul style="margin-top: 10px; padding-left: 20px;">
                            <li>"What is <%= topicTitle.toLowerCase() %>?"</li>
                            <li>"Can you give me an example?"</li>
                            <li>"What's a quick tip?"</li>
                        </ul>
                    </div>
                </div>

                <!-- Content Section -->
                <div class="content-section">
                    <div class="content-box">
                        <h3>Key Concepts</h3>
                        <div class="content-text">
                            <%= mainContent %>
                        </div>
                        
                        <div class="tip-box">
                            <div class="tip-title">
                                <i class="fas fa-lightbulb"></i> Quick Tip
                            </div>
                            <div class="content-text">
                                <% if (currentTopic == 1) { %>
                                    Practice the 5-5-5 breathing technique: Breathe in for 5 seconds, hold for 5 seconds, breathe out for 5 seconds.
                                <% } else if (currentTopic == 2) { %>
                                    Use the "two-minute rule": If a task takes less than two minutes, do it immediately.
                                <% } else { %>
                                    Set aside 15 minutes daily for "me time" - no screens, just relaxation.
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="example-box">
                            <div class="example-title">
                                <i class="fas fa-eye"></i> Example
                            </div>
                            <div class="content-text">
                                <%= exampleContent %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chat Messages Container -->
                <div class="chat-messages-container" id="chatMessages">
                    <!-- Empty state message -->
                    <div class="message-empty-state" id="emptyState">
                        <i class="fas fa-comment-alt" style="font-size: 24px; margin-bottom: 10px; color: #D7923B;"></i><br>
                        No messages yet. Type a question or use the buttons below to start the conversation!
                    </div>
                </div>

                <!-- Chat Input Area -->
                <div class="chat-input-area">
                    <div class="input-wrapper">
                        <input type="text" 
                               class="chat-input" 
                               id="messageInput"
                               placeholder="Ask about <%= topicTitle.toLowerCase() %>..."
                               onkeypress="handleKeyPress(event)">
                        <button class="send-button" onclick="sendMessage()">
                            <i class="fas fa-paper-plane"></i> Send
                        </button>
                    </div>
                    
                    <div class="action-buttons">
                        <button class="action-btn" onclick="explainMore()">
                            <i class="fas fa-info-circle"></i> Explain More
                        </button>
                        <button class="action-btn" onclick="showExample()">
                            <i class="fas fa-chart-bar"></i> Show Example
                        </button>
                        <button class="action-btn" onclick="showTip()">
                            <i class="fas fa-lightbulb"></i> Show Tip
                        </button>
                        <% if (currentTopic < 3) { %>
                            <button class="action-btn next" onclick="nextTopic()">
                                Next Topic <i class="fas fa-arrow-right"></i>
                            </button>
                        <% } else { %>
                            <button class="action-btn next" onclick="completeModule()">
                                Complete Module <i class="fas fa-check"></i>
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>

        <% } else { %>
            <!-- Module Complete Screen -->
            <div class="module-complete">
                <h2><i class="fas fa-trophy"></i> Great job!</h2>
                <p>You've just mastered the basics of the Stress Module — you're one step closer to better mental wellness!</p>
                
                <div class="resources-section">
                    <h3><i class="fas fa-book-open"></i> Additional Resources</h3>
                    <p>Continue your learning journey with these additional resources:</p>
                    
                    <div class="resource-list">
                        <div class="resource-item">
                            <h4>Managing Stress in Daily Life</h4>
                            <p>Learn how to identify sources of everyday stress, and build healthy habits to manage them effectively.</p>
                        </div>
                        <div class="resource-item">
                            <h4>Time Management to Reduce Stress</h4>
                            <p>Understand how effective time management can lower stress levels and improve productivity.</p>
                        </div>
                        <div class="resource-item">
                            <h4>Mindfulness Meditation Guide</h4>
                            <p>Step-by-step guide to practicing mindfulness meditation for stress reduction.</p>
                        </div>
                    </div>
                </div>
                
                <div class="completion-buttons">
                    <a href="<%= contextPath %>/dashboard" class="nav-btn">
                        <i class="fas fa-home"></i> Return to Dashboard
                    </a>
                    <a href="<%= contextPath %>/ai/learn" class="nav-btn secondary">
                        <i class="fas fa-book"></i> Explore Another Topic
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <script>
        // Topic data for dynamic responses
        const topicData = {
            1: {
                title: "Understanding Stress",
                explainMore: "Stress is your body's response to any demand or threat. When you feel threatened, your nervous system responds by releasing stress hormones like adrenaline and cortisol. These hormones prepare your body for emergency action: your heart pounds faster, muscles tighten, blood pressure rises, breath quickens, and your senses become sharper.",
                showExample: "When you have a big presentation at work, you might experience acute stress: heart races, palms sweat, mind goes blank. This is your body's natural fight-or-flight response preparing you to perform.",
                showTip: "💡 **Quick Tip:** Practice the 5-5-5 breathing technique: Inhale for 5 seconds, hold for 5 seconds, exhale for 5 seconds. Repeat 5 times to calm your nervous system.",
                responses: {
                    "what is stress": "Stress is your body's response to pressure or demand. It can be positive (eustress) which motivates you, or negative (distress) which can harm your health.",
                    "symptoms": "Common stress symptoms include: Physical - headaches, muscle tension, fatigue; Emotional - anxiety, irritability, depression; Behavioral - overeating, insomnia, procrastination.",
                    "causes": "Stress can be caused by work pressure, financial worries, relationship issues, health concerns, major life changes, or daily hassles like traffic or deadlines.",
                    "effects": "Chronic stress can lead to serious health issues: heart disease, high blood pressure, diabetes, depression, anxiety disorders, and weakened immune system."
                }
            },
            2: {
                title: "Coping Strategies",
                explainMore: "Coping strategies are techniques that help you manage stressful situations. They can be problem-focused (solving the issue) or emotion-focused (managing your feelings). Effective strategies include time management, relaxation techniques, physical activity, and seeking social support.",
                showExample: "When facing multiple deadlines, try this approach: 1) List all tasks, 2) Prioritize by urgency and importance, 3) Break large tasks into smaller steps, 4) Set realistic time blocks, 5) Take regular breaks to maintain focus.",
                showTip: "💡 **Quick Tip:** Use the 'two-minute rule': If a task takes less than two minutes, do it immediately instead of adding it to your mental to-do list.",
                responses: {
                    "time management": "Try the Pomodoro Technique: Work for 25 minutes, then take a 5-minute break. After 4 cycles, take a longer 15-30 minute break. This helps maintain focus and prevent burnout.",
                    "relaxation": "Progressive muscle relaxation: Tense and then relax each muscle group from toes to head. Start with your feet, then calves, thighs, abdomen, chest, arms, hands, shoulders, neck, and face.",
                    "exercise": "Even 10 minutes of brisk walking can release endorphins that improve mood and reduce stress. Regular exercise also helps regulate sleep and boost energy levels.",
                    "social support": "Talking to friends, family, or a therapist about your stress can provide emotional support, practical solutions, and help you feel less isolated."
                }
            },
            3: {
                title: "Maintaining Long-Term Stress Management",
                explainMore: "Long-term stress management involves building resilience and healthy habits. This includes regular self-care, setting boundaries, maintaining social connections, practicing mindfulness, and developing a growth mindset. It's about creating a sustainable lifestyle that prevents burnout.",
                showExample: "Create a weekly wellness routine: Monday - Yoga for flexibility, Tuesday - Journaling for reflection, Wednesday - Walk in nature, Thursday - Digital detox hour, Friday - Connect with friends, Saturday - Creative hobby, Sunday - Planning and reflection for the week ahead.",
                showTip: "💡 **Quick Tip:** Set aside 15 minutes daily for 'me time' - no screens, just relaxation or an activity you genuinely enjoy. This small daily investment in yourself pays big dividends in stress reduction.",
                responses: {
                    "prevent burnout": "Recognize early warning signs like constant fatigue, cynicism, and reduced performance. Take regular breaks, set clear work-life boundaries, and don't hesitate to say no when necessary.",
                    "mindfulness": "Practice daily mindfulness: Start with 5 minutes of focused breathing. Notice your thoughts without judgment. Use apps like Headspace or Calm for guided sessions.",
                    "routine": "Establish consistent sleep, meal, and exercise routines. Our bodies thrive on predictability. Aim for 7-9 hours of sleep, regular meal times, and daily physical activity.",
                    "growth mindset": "View challenges as opportunities to learn and grow rather than as threats. Embrace failures as learning experiences and celebrate small victories along the way."
                }
            }
        };

        // Initialize with current topic
        const currentTopic = <%= currentTopic %>;
        let hasMessages = false;

        // Hide empty state when messages exist
        function updateEmptyState() {
            const emptyState = document.getElementById('emptyState');
            if (hasMessages && emptyState) {
                emptyState.style.display = 'none';
            }
        }

        // Add message to chat with proper formatting
        function addMessage(sender, content, isTip = false, isExample = false) {
            const chatMessages = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}`;
            
            // Create message header
            const headerDiv = document.createElement('div');
            headerDiv.className = `message-header ${sender}`;
            
            const iconSpan = document.createElement('span');
            iconSpan.className = 'message-icon';
            iconSpan.innerHTML = sender === 'ai' ? '<i class="fas fa-robot"></i>' : '<i class="fas fa-user"></i>';
            
            const senderSpan = document.createElement('span');
            senderSpan.textContent = sender === 'ai' ? 'AI Assistant' : 'You';
            
            headerDiv.appendChild(iconSpan);
            headerDiv.appendChild(senderSpan);
            
            // Create message content
            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            
            // Format special message types
            if (isTip) {
                const tipDiv = document.createElement('div');
                tipDiv.className = 'tip-message';
                tipDiv.innerHTML = content;
                contentDiv.appendChild(tipDiv);
            } else if (isExample) {
                const exampleDiv = document.createElement('div');
                exampleDiv.className = 'example-message';
                exampleDiv.innerHTML = content;
                contentDiv.appendChild(exampleDiv);
            } else {
                contentDiv.textContent = content;
            }
            
            // Assemble message
            messageDiv.appendChild(headerDiv);
            messageDiv.appendChild(contentDiv);
            chatMessages.appendChild(messageDiv);
            
            // Update state
            hasMessages = true;
            updateEmptyState();
            
            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        // Send user message
        function sendMessage() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            
            if (message === '') return;
            
            // Add user message
            addMessage('user', message);
            input.value = '';
            
            // Simulate AI response after delay
            setTimeout(() => {
                // Check for predefined responses
                const topic = topicData[currentTopic];
                let response = topic.responses[message.toLowerCase()];
                
                if (!response) {
                    // Check for keywords in message
                    const lowerMessage = message.toLowerCase();
                    if (lowerMessage.includes('tip')) {
                        response = topic.showTip;
                    } else if (lowerMessage.includes('example') || lowerMessage.includes('instance')) {
                        response = topic.showExample;
                    } else if (lowerMessage.includes('explain') || lowerMessage.includes('what') || lowerMessage.includes('how')) {
                        response = topic.explainMore;
                    } else {
                        // Generic response
                        const genericResponses = [
                            "I'd be happy to help with that! Would you like me to explain more, give an example, or share a tip about " + topic.title.toLowerCase() + "?",
                            "That's an interesting question about " + topic.title.toLowerCase() + ". Could you be more specific about what you'd like to know?",
                            "Great question! For " + topic.title.toLowerCase() + ", you might find it helpful if I explain the concept, show an example, or give you a practical tip."
                        ];
                        response = genericResponses[Math.floor(Math.random() * genericResponses.length)];
                    }
                }
                
                addMessage('ai', response);
            }, 800); // Shorter delay for better UX
        }

        // Handle Enter key
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
                event.preventDefault();
            }
        }

        // Action buttons
        function explainMore() {
            const response = topicData[currentTopic].explainMore;
            addMessage('ai', response);
        }

        function showExample() {
            const response = topicData[currentTopic].showExample;
            addMessage('ai', response, false, true);
        }

        function showTip() {
            const response = topicData[currentTopic].showTip;
            addMessage('ai', response, true, false);
        }

        function nextTopic() {
            if (currentTopic < 3) {
                window.location.href = '<%= contextPath %>/ai/learn/module?module=<%= module %>&topic=' + (currentTopic + 1);
            }
        }

        function completeModule() {
            window.location.href = '<%= contextPath %>/ai/learn/module?module=<%= module %>&topic=complete';
        }

        // Focus on input when page loads
        window.addEventListener('load', function() {
            const input = document.getElementById('messageInput');
            if (input) {
                input.focus();
            }
        });
    </script>
</body>
</html>