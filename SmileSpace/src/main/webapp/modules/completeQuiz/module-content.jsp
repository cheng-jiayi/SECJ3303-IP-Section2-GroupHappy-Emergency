<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    String videoUrl = (String) request.getAttribute("videoUrl");
    String[] keyPoints = null;
    
    if (module != null && module.getKeyPoints() != null) {
        keyPoints = module.getKeyPoints().split("\\$\\$");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= module.getTitle() %> - smilespace</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #FFF8E8;
            color: #6B4F36;
            min-height: 100vh;
        }
        
        .header {
            background-color: #FFF3C8;
            padding: 15px 40px;
            border-bottom: 2px solid #E8D9B5;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .home-link {
            text-decoration: none;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: opacity 0.2s;
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

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }
        
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .module-header {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .module-badge {
            background-color: #FFF3C8;
            color: #CF8224;
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 15px;
        }
        
        .module-title {
            font-size: 36px;
            color: #6B4F36;
            margin-bottom: 15px;
            font-weight: 700;
            line-height: 1.2;
        }
        
        .module-description {
            color: #8D735B;
            font-size: 18px;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto 30px;
            padding: 20px;
            background-color: #FFFDF6;
            border-radius: 12px;
            border-left: 4px solid #CF8224;
        }
        
        .video-container {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #E8D9B5;
        }
        
        .video-title {
            color: #6B4F36;
            font-size: 24px;
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .video-wrapper {
            position: relative;
            width: 100%;
            padding-bottom: 56.25%; /* 16:9 Aspect Ratio */
            height: 0;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        
        .video-wrapper iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        
        .video-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #E8D9B5;
            color: #8D735B;
            font-size: 14px;
        }
        
        .lecturer-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .lecturer-avatar {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #CF8224 0%, #E8A95E 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: bold;
        }
        
        .lecturer-details h4 {
            color: #6B4F36;
            margin-bottom: 5px;
            font-size: 16px;
        }
        
        .lecturer-details p {
            color: #8D735B;
            font-size: 14px;
        }
        
        .learning-points {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #E8D9B5;
        }
        
        .points-title {
            color: #6B4F36;
            font-size: 24px;
            margin-bottom: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .points-list {
            list-style: none;
        }
        
        .points-list li {
            padding: 15px 0;
            color: #8D735B;
            display: flex;
            align-items: flex-start;
            gap: 15px;
            border-bottom: 1px solid #F0E9DD;
            font-size: 16px;
            line-height: 1.5;
        }
        
        .points-list li:last-child {
            border-bottom: none;
        }
        
        .points-list li::before {
            content: '✓';
            color: #4CAF50;
            font-size: 20px;
            font-weight: bold;
            flex-shrink: 0;
            margin-top: 2px;
        }
        
        .action-section {
            text-align: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #E8D9B5;
        }
        
        .completion-text {
            color: #8D735B;
            font-size: 18px;
            margin-bottom: 25px;
        }
        
        .btn-finish {
            background: linear-gradient(135deg, #CF8224 0%, #E8A95E 100%);
            color: white;
            border: none;
            padding: 16px 50px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }
        
        .btn-finish:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(207, 130, 36, 0.3);
        }
        
        .progress-bar {
            width: 100%;
            height: 8px;
            background-color: #F0E9DD;
            border-radius: 4px;
            margin-bottom: 15px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #CF8224 0%, #E8A95E 100%);
            width: 100%;
            border-radius: 4px;
        }
        
        .time-display {
            color: #8D735B;
            font-size: 14px;
            text-align: right;
            margin-bottom: 15px;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .header {
                padding: 15px 20px;
            }
            
            .module-title {
                font-size: 28px;
            }
            
            .video-container, .learning-points {
                padding: 20px;
            }
            
            .video-meta {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .btn-finish {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="header">
        <a href="<%= request.getContextPath() %>/quiz-dashboard" class="home-link">
            <div class="logo">
                <i class="fas fa-home"></i>
                SmileSpace
            </div>
        </a>
    </div>
    
    <div class="container">
        <div class="module-header">
            <div class="module-badge">
                <%= module.getId() %> - <%= module.getCategory() %> Module
            </div>
            <h1 class="module-title"><%= module.getTitle() %></h1>
            <p class="module-description"><%= module.getDescription() %></p>
        </div>
        
        <div class="progress-bar">
            <div class="progress-fill"></div>
        </div>
        <div class="time-display">Video duration: <%= module.getEstimatedDuration() %></div>
        
        <div class="video-container">
            <h3 class="video-title">
                <i class="fas fa-play-circle"></i>
                Learning Video
            </h3>
            
            <div class="video-wrapper">
                <% if (videoUrl != null && !videoUrl.isEmpty()) { 
                    // Convert YouTube URL to embed format
                    String embedUrl = videoUrl;
                    if (videoUrl.contains("youtube.com/watch")) {
                        embedUrl = videoUrl.replace("watch?v=", "embed/");
                    } else if (videoUrl.contains("youtu.be/")) {
                        embedUrl = videoUrl.replace("youtu.be/", "youtube.com/embed/");
                    }
                %>
                    <iframe src="<%= embedUrl %>" 
                            title="<%= module.getTitle() %>" 
                            frameborder="0" 
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                            allowfullscreen>
                    </iframe>
                <% } else { %>
                    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: #2c3e50; display: flex; align-items: center; justify-content: center; color: white; border-radius: 10px;">
                        <div style="text-align: center;">
                            <i class="fas fa-video" style="font-size: 48px; margin-bottom: 15px;"></i>
                            <p>Video Content</p>
                            <p style="font-size: 14px; opacity: 0.8;">Learning video would be displayed here</p>
                        </div>
                    </div>
                <% } %>
            </div>
            
            <div class="video-meta">
                <div class="lecturer-info">
                    <div class="lecturer-avatar">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div class="lecturer-details">
                        <h4><%= module.getAuthorName() %></h4>
                        <p>Clinical Psychologist</p>
                    </div>
                </div>
                <div class="video-duration">
                    <i class="far fa-clock"></i>
                    Duration: <%= module.getEstimatedDuration() %>
                </div>
            </div>
        </div>
        
        <div class="learning-points">
            <h3 class="points-title">
                <i class="fas fa-bullseye"></i>
                Key Learning Points
            </h3>
            <ul class="points-list">
                <% if (keyPoints != null && keyPoints.length > 0) {
                    for (String point : keyPoints) { %>
                        <li><%= point %></li>
                <%   }
                   } else { %>
                    <li>Identify common sources of daily stress in academic and personal life</li>
                    <li>Recognize physical and emotional signals of stress before they become overwhelming</li>
                    <li>Apply simple relaxation techniques like deep breathing and short meditation</li>
                    <li>Develop a personalized "Three-Minute Relax Routine" for daily practice</li>
                    <li>Build healthy coping strategies to maintain balance between study, relationships, and rest</li>
                    <li>Create a sustainable stress management plan tailored to your lifestyle</li>
                <% } %>
            </ul>
        </div>
        
        <div class="action-section">
            <p class="completion-text">
                You have completed the learning module. Ready to test your knowledge?
            </p>
            <a href="quiz?action=start&moduleId=<%= module.getId() %>" class="btn-finish">
                <i class="fas fa-flag-checkered"></i>
                Finish & Proceed to Quiz
            </a>
        </div>
    </div>
    
    <script>
        // Video completion tracking
        const videoFrame = document.querySelector('iframe');
        const progressFill = document.querySelector('.progress-fill');
        const finishButton = document.querySelector('.btn-finish');
        
        // Enable button immediately for now
        finishButton.style.opacity = '1';
        finishButton.style.cursor = 'pointer';
        progressFill.style.width = '100%';
        
        // Chat icon functionality
        document.querySelector('.chat-icon')?.addEventListener('click', function() {
            alert('Chat support feature would open here. In a real application, this would connect you with a counselor or support assistant.');
        });
    </script>
</body>
</html>