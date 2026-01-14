<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
    if (contextPath == null || contextPath.isEmpty()) {
        contextPath = "";
    }
    
    String userFullName = (String) session.getAttribute("userFullName");
    if (userFullName == null) {
        userFullName = "Guest Student";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Learning Hub - SmileSpace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body {
            background-color: #FFF8E8;
            font-family: 'Preahvihear', sans-serif;
            color: #6B4F36;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            width: 80%;
            text-align: left;
            margin-top: 100px;
        }
        
        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-size: 20px;
            font-weight: bold;
        }

        .home-link {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none; 
            color: #6B4F36; 
            transition: opacity 0.2s;
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none; 
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: flex-end; 
            margin-left: auto;    
        }
        
        .logo i {
            color: #F0A548;
            font-size: 22px;
        }

        h1 {
            font-size: 36px;
            font-weight: 600;
            text-align: left;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .subtitle {
            font-size: 20px;
            margin-bottom: 35px;
            text-align: left;
            font-weight: 400;
            color: #CF8224;
        }

        .card-container {
            display: flex;
            justify-content: flex-start;
            gap: 40px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .card {
            background-color: #FFF3C8;
            width: 260px;
            padding: 5px;
            border-radius: 12px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: 0.2s;
            text-align: center;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card img {
            height: 130px !important;
            display: block !important;
            margin: 0 auto !important;
        }
        
        .card-title {
            font-size: 18px;
            font-weight: 600;
            text-align: center;
            color: #CF8224;
        }
        
        .ai-assistant-container {
            margin-top: 50px;
            text-align: center;
            padding: 20px;
        }

        .ai-trigger {
            background-color: #CF8224;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            margin-top: 20px;
        }

        .ai-trigger:hover {
            background-color: #B3711E;
            transform: translateY(-2px);
            box-shadow: 0px 4px 8px rgba(0,0,0,0.15);
        }
        
        /* Popup Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-overlay.active {
            display: flex;
        }

        .ai-modal {
            background-color: #FFF8E8;
            border-radius: 15px;
            width: 90%;
            max-width: 400px;
            box-shadow: 0px 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .modal-header {
            background-color: #CF8224;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .close-btn {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .close-btn:hover {
            transform: scale(1.1);
        }

        .modal-body {
            padding: 30px;
            text-align: center;
        }

        .ai-greeting {
            font-size: 18px;
            color: #6B4F36;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        .ai-avatar {
            font-size: 48px;
            margin-bottom: 20px;
            color: #CF8224;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
        }

        .action-btn {
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid #CF8224;
            min-width: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .action-btn.learn {
            background-color: #CF8224;
            color: white;
        }

        .action-btn.learn:hover {
            background-color: #B3711E;
            transform: translateY(-2px);
        }

        .action-btn.chat {
            background-color: transparent;
            color: #CF8224;
        }

        .action-btn.chat:hover {
            background-color: #FFF3C8;
            transform: translateY(-2px);
        }
        
        /* Welcome message */
        .welcome-message {
            font-size: 18px;
            color: #6B4F36;
            margin-bottom: 30px;
            text-align: center;
            background-color: #FFF3C8;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #CF8224;
        }
        
        @media (max-width: 768px) {
            .container {
                width: 95%;
                margin-top: 80px;
            }
            
            .top-right {
                position: static;
                text-align: center;
                margin-bottom: 20px;
            }
            
            .card-container {
                justify-content: center;
                gap: 20px;
            }
            
            .card {
                width: 100%;
                max-width: 260px;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .action-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<div class="top-right">
    <a href="<%= contextPath %>/dashboard" class="home-link">
        <div class="logo">
            <i class="fas fa-home"></i>
            SmileSpace
        </div>
    </a>
</div>

<div class="container">

    <h1>AI Learning Hub</h1>

    <div class="subtitle">
        Choose a Topic to learn :
    </div>

    <div class="card-container">
        <!-- AI-Assisted Stress Module -->
        <div class="card" onclick="window.location.href='<%= contextPath %>/ai/learn/module?module=stress&topic=1'">
            <img src="<%= contextPath %>/modules/completeQuiz/images/Picture2.png" alt="Stress Module">
            <div class="card-title">AI Stress Assistant</div>
        </div>

        <!-- AI Anxiety Module -->
        <div class="card" onclick="openAIModal()">
            <img src="<%= contextPath %>/modules/completeQuiz/images/Picture3.png" alt="Anxiety Module">
            <div class="card-title">AI Anxiety Helper</div>
        </div>

        <!-- AI Sleep Module -->
        <div class="card" onclick="openAIModal()">
            <img src="<%= contextPath %>/modules/completeQuiz/images/Picture4.png" alt="Sleep Module">
            <div class="card-title">AI Sleep Coach</div>
        </div>

        <!-- AI Self-Esteem Module -->
        <div class="card" onclick="openAIModal()">
            <img src="<%= contextPath %>/modules/completeQuiz/images/Picture5.png" alt="Self-Esteem Module">
            <div class="card-title">AI Confidence Builder</div>
        </div>

        <!-- AI Mindfulness Module -->
        <div class="card" onclick="openAIModal()">
            <img src="<%= contextPath %>/modules/completeQuiz/images/Picture6.png" alt="Mindfulness Module">
            <div class="card-title">AI Mindfulness Guide</div>
        </div>
    </div>
    
</div>

<!-- AI Assistant Modal -->
<div class="modal-overlay" id="aiModal">
    <div class="ai-modal">
        <div class="modal-header">
            <div class="modal-title">
                <i class="fas fa-robot"></i>
                AI Assistant
            </div>
            <button class="close-btn" onclick="closeAIModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="ai-avatar">
                <i class="fas fa-robot"></i>
            </div>
            <div class="ai-greeting">
                Hi <%= userFullName %>! Ready to choose a topic to learn today? I'm here to help you learn and grow.
            </div>
            <div class="action-buttons">
                <button class="action-btn learn" onclick="startLearning()">
                    <i class="fas fa-book"></i>
                    Learn
                </button>
                <button class="action-btn chat" onclick="startChat()">
                    <i class="fas fa-comments"></i>
                    Chat
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // AI Modal functions
    function openAIModal() {
        document.getElementById('aiModal').classList.add('active');
    }
    
    function closeAIModal() {
        document.getElementById('aiModal').classList.remove('active');
    }
    
    function startLearning() {
        window.location.href = '<%= contextPath %>/ai/learn/module?module=stress&topic=1';
    }
    
    function startChat() {
        window.location.href = '<%= contextPath %>/ai/chat';
    }
    
    // Close modal when clicking outside
    document.getElementById('aiModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeAIModal();
        }
    });
</script>

</body>
</html>