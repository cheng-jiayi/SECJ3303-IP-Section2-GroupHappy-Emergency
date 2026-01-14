<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is a student
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null || !"student".equals(userRole)) {
        response.sendRedirect("../loginPage.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - SmileSpace</title>
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
        .user-menu {
            position: relative;
        }
        .user-btn {
            background: #D7923B;
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 20px;
        }
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 200px;
            display: none;
        }
        .dropdown.show { display: block; }
        .user-info {
            padding: 15px;
            background: #FFF3C8;
            border-bottom: 2px solid #E8D4B9;
        }
        .user-name { font-weight: bold; }
        .user-role {
            background: #D7923B;
            color: white;
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 12px;
            display: inline-block;
            margin-top: 5px;
        }
        .menu-item {
            padding: 12px 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #6B4F36;
            border-bottom: 1px solid #eee;
        }
        .menu-item:hover { background: #FFF8E8; }
        .menu-item.logout { color: #E74C3C; }
        .container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .welcome {
            margin-bottom: 40px;
        }
        .welcome h2 {
            color: #D7923B;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
        }
        .card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
        .card-icon {
            width: 80px;
            height: 80px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: white;
            font-size: 30px;
        }
        .card-title {
            color: #CF8224;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .card-desc {
            color: #8B7355;
            font-size: 14px;
        }
        
        /* Chatbox Styles */
        .chatbox-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
        }
        
        .chatbox-toggle {
            width: 60px;
            height: 60px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(215, 146, 59, 0.3);
            transition: all 0.3s;
        }
        
        .chatbox-toggle:hover {
            background: #CF8224;
            transform: scale(1.05);
        }
        
        .chatbox {
            position: absolute;
            bottom: 70px;
            right: 0;
            width: 300px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.2);
            display: none;
            flex-direction: column;
            overflow: hidden;
        }
        
        .chatbox.active {
            display: flex;
        }
        
        .chatbox-header {
            background: #D7923B;
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .chatbox-header h3 {
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .close-chat {
            background: none;
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
        }
        
        .chatbox-body {
            padding: 20px;
            background: #FFF8E8;
        }
        
        .chat-options {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .chat-option {
            background: white;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: #6B4F36;
        }
        
        .chat-option:hover {
            background: #FFF3C8;
            border-color: #D7923B;
            transform: translateY(-2px);
        }
        
        .chat-option-icon {
            width: 40px;
            height: 40px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }
        
        .chat-option-content {
            flex: 1;
        }
        
        .chat-option-title {
            font-weight: bold;
            color: #CF8224;
            margin-bottom: 5px;
        }
        
        .chat-option-desc {
            font-size: 12px;
            color: #8B7355;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="logo">
            <h1>SmileSpace</h1>
        </div>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
            <div class="dropdown" id="dropdown">
                <div class="user-info">
                    <div class="user-name"><%= userFullName %></div>
                    <div class="user-role">Student</div>
                </div>
                <a href="../profiles/studentProfile.jsp" class="menu-item">
                    <i class="fas fa-user-edit"></i> Manage Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="welcome">
            <h2>Welcome back, <%= userFullName %>!</h2>
            <p>What would you like to do today?</p>
        </div>

        <div class="card-container">
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/student-learning-modules'">
                <div class="card-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="card-title">Explore Learning Resources</div>
                <div class="card-desc">Access educational materials</div>
            </div>

            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/mood'">
                <div class="card-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <div class="card-title">Track My Mood</div>
                <div class="card-desc">Monitor your emotional wellbeing</div>
            </div>

            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/modules/selfAssessmentModule/assessment.jsp'">
                <div class="card-icon">
                    <i class="fas fa-clipboard-check"></i>
                </div>
                <div class="card-title">Take Self-Assessment</div>
                <div class="card-desc">Evaluate your mental health</div>
            </div>

            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/modules/peerSupportForumModule/forumHome.jsp'">
                <div class="card-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="card-title">Join Peer Support</div>
                <div class="card-desc">Connect with other students</div>
            </div>

            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/counseling?action=viewSessions'">
                <div class="card-icon">
                    <i class="fas fa-comments"></i>
                </div>
                <div class="card-title">Manage Counseling</div>
                <div class="card-desc">Schedule counseling sessions</div>
            </div>

            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/modules/feedbackAndAnalyticsModule/feedback.jsp'">
                <div class="card-icon">
                    <i class="fas fa-comment-dots"></i>
                </div>
                <div class="card-title">Share Feedback</div>
                <div class="card-desc">Share your experience</div>
            </div>
        </div>
    </div>

    <!-- Chatbox -->
    <div class="chatbox-container">
        <div class="chatbox" id="chatbox">
            <div class="chatbox-header">
                <h3><i class="fas fa-robot"></i> AI Assistant</h3>
                <button class="close-chat" id="closeChat">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="chatbox-body">
                <div class="chat-options">
                    <div style="margin-bottom:15px; padding:10px; background:#FFF3C8; border-radius:10px;">
                        <strong>Hi <%= userFullName %>!</strong><br>
                        Ready to explore mental health topics today?
                    </div>
                    <a href="<%= request.getContextPath() %>/modules/AIAssistant/Learn/AILearningHub.jsp" class="chat-option">
                        <div class="chat-option-icon">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <div class="chat-option-content">
                            <div class="chat-option-title">Learn</div>
                            <div class="chat-option-desc">Learn mental health knowledge with AI</div>
                        </div>
                    </a>
                    
                    <a href="<%= request.getContextPath() %>/modules/AIAssistant/Chat/AIConversationHub.jsp" class="chat-option">
                        <div class="chat-option-icon">
                            <i class="fas fa-comments"></i>
                        </div>
                        <div class="chat-option-content">
                            <div class="chat-option-title">Chat</div>
                            <div class="chat-option-desc">Get advice and recommendations</div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
        <div class="chatbox-toggle" id="chatToggle">
            <i class="fas fa-robot"></i>
        </div>
    </div>

    <script>
        // User dropdown
        const userBtn = document.getElementById('userBtn');
        const dropdown = document.getElementById('dropdown');
        
        userBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('show');
        });
        
        document.addEventListener('click', function() {
            dropdown.classList.remove('show');
        });
        
        dropdown.addEventListener('click', function(e) {
            e.stopPropagation();
        });
        
        // Chatbox functionality
        const chatToggle = document.getElementById('chatToggle');
        const chatbox = document.getElementById('chatbox');
        const closeChat = document.getElementById('closeChat');
        
        chatToggle.addEventListener('click', function() {
            chatbox.classList.add('active');
        });
        
        closeChat.addEventListener('click', function() {
            chatbox.classList.remove('active');
        });
        
        // Close chatbox when clicking outside
        document.addEventListener('click', function(event) {
            if (!chatbox.contains(event.target) && !chatToggle.contains(event.target)) {
                chatbox.classList.remove('active');
            }
        });
    </script>
</body>
</html>