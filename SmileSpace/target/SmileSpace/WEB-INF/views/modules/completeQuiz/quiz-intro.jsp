<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    String[] contentOutline = (String[]) request.getAttribute("contentOutline");
    String[] learningGuide = (String[]) request.getAttribute("learningGuide");
    String[] keyPoints = (String[]) request.getAttribute("keyPoints");
    
    // Use database fields
    if (contentOutline == null && module != null && module.getContentOutline() != null) {
        contentOutline = module.getContentOutline().split("\\$\\$");
    }
    if (learningGuide == null && module != null && module.getLearningGuide() != null) {
        learningGuide = module.getLearningGuide().split("\\$\\$");
    }
    
    // Get module ID and category for URLs
    String moduleId = module != null ? module.getId() : "";
    String category = module != null ? module.getCategory() : "General";
    String encodedCategory = URLEncoder.encode(category, "UTF-8");
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
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }
        
        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .module-card {
            background-color: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #E8D9B5;
        }
        
        .module-id {
            background-color: #FFF3C8;
            color: #CF8224;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 15px;
        }
        
        .module-title {
            font-size: 32px;
            color: #6B4F36;
            margin-bottom: 20px;
            font-weight: 600;
            line-height: 1.3;
        }
        
        .module-description {
            color: #8D735B;
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 30px;
            padding: 25px;
            background-color: #FFFDF6;
            border-radius: 12px;
            border-left: 4px solid #CF8224;
        }
        
        .lecturer-info {
            display: flex;
            align-items: center;
            gap: 15px;
            background-color: #FFFDF6;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 1px solid #E8D9B5;
        }
        
        .lecturer-avatar {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #CF8224 0%, #E8A95E 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
        }
        
        .lecturer-details h4 {
            color: #6B4F36;
            margin-bottom: 5px;
            font-size: 18px;
            font-weight: 600;
        }
        
        .lecturer-details p {
            color: #8D735B;
            font-size: 14px;
        }
        
        .content-sections {
            display: grid;
            gap: 25px;
            margin: 40px 0;
        }
        
        .section-card {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #E8D9B5;
        }
        
        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #6B4F36;
            font-size: 22px;
            margin-bottom: 20px;
            font-weight: 600;
            padding-bottom: 15px;
            border-bottom: 2px solid #E8D9B5;
        }
        
        .section-icon {
            font-size: 24px;
            color: #CF8224;
        }
        
        .learning-guide-list, .content-list {
            list-style: none;
        }
        
        .learning-guide-list li, .content-list li {
            padding: 12px 0;
            color: #8D735B;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            border-bottom: 1px solid #F0E9DD;
        }
        
        .learning-guide-list li:last-child, .content-list li:last-child {
            border-bottom: none;
        }
        
        .learning-guide-list li::before, .content-list li::before {
            content: '•';
            color: #CF8224;
            font-size: 24px;
            line-height: 1;
            flex-shrink: 0;
        }
        
        .tip-box {
            background: linear-gradient(135deg, #FFF9E6 0%, #FFEBB2 100%);
            border-left: 4px solid #CF8224;
            padding: 25px;
            border-radius: 12px;
            margin: 25px 0;
        }
        
        .tip-title {
            color: #B56F1A;
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
        }
        
        .tip-box p {
            color: #8D735B;
            font-size: 16px;
            line-height: 1.6;
        }
        
        .action-buttons {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
        }
        
        .btn {
            padding: 14px 35px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            min-width: 160px;
        }
        
        .btn-secondary {
            background-color: white;
            color: #CF8224;
            border: 2px solid #CF8224;
        }
        
        .btn-secondary:hover {
            background-color: #FFF3C8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(207, 130, 36, 0.2);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #CF8224 0%, #E8A95E 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(207, 130, 36, 0.3);
        }
        
        .info-badge {
            display: inline-block;
            padding: 6px 15px;
            background-color: #E8F5E9;
            color: #2E7D32;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 15px;
        }
        
        .duration-info {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #8D735B;
            margin-top: 10px;
            font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .module-card {
                padding: 25px;
            }
            
            .module-title {
                font-size: 26px;
            }
            
            .module-description {
                padding: 20px;
                font-size: 16px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn {
                width: 100%;
            }
            
            .header {
                padding: 15px 20px;
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
        <div class="module-card">
            <div class="module-id">
                <%= module.getId() %> - <%= module.getCategory() %> Module
                <span class="info-badge"><%= module.getLevel() %></span>
            </div>
            
            <h1 class="module-title"><%= module.getTitle() %></h1>
            
            <div class="module-description">
                <%= module.getDescription() %>
            </div>
            
            <div class="lecturer-info">
                <div class="lecturer-avatar">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="lecturer-details">
                    <h4><%= module.getAuthorName() %></h4>
                    <p>Clinical Psychologist</p>
                    <div class="duration-info">
                        <i class="far fa-clock"></i>
                        <span>Estimated time: <%= module.getEstimatedDuration() %></span>
                    </div>
                </div>
            </div>
            
            <div class="content-sections">
                <div class="section-card">
                    <h3 class="section-title">
                        <span class="section-icon"><i class="fas fa-book-open"></i></span>
                        Learning Guide
                    </h3>
                    <ul class="learning-guide-list">
                        <% if (learningGuide != null && learningGuide.length > 0) {
                            for (String guide : learningGuide) { %>
                                <li><%= guide %></li>
                        <%   }
                           } else { %>
                            <li>Estimated time: <%= module.getEstimatedDuration() %></li>
                            <li>Includes short video + interactive quiz</li>
                            <li>Tip: Take short notes while learning and reflect at the end</li>
                        <% } %>
                    </ul>
                </div>
                
                <div class="section-card">
                    <h3 class="section-title">
                        <span class="section-icon"><i class="fas fa-list-alt"></i></span>
                        Content Outline
                    </h3>
                    <ul class="content-list">
                        <% if (contentOutline != null && contentOutline.length > 0) {
                            for (String outline : contentOutline) { %>
                                <li><%= outline %></li>
                        <%   }
                           } else { %>
                            <li>Common daily stressors (academic, social, time pressure)</li>
                            <li>Recognizing physical and emotional stress signals</li>
                            <li>Simple relaxation techniques (breathing, music, short meditation)</li>
                            <li>"Three-Minute Relax Routine" daily practice</li>
                        <% } %>
                    </ul>
                </div>
                
                <% if (module.getLearningTip() != null && !module.getLearningTip().isEmpty()) { %>
                <div class="tip-box">
                    <div class="tip-title">
                        <i class="fas fa-lightbulb"></i>
                        Learning Tip
                    </div>
                    <p><%= module.getLearningTip() %></p>
                </div>
                <% } %>
            </div>
            
            <div class="action-buttons">
                 <a href="quiz-dashboard?category=<%= encodedCategory %>" class="btn btn-secondary">
                    <i class="fas fa-th-large"></i>
                    Back to Dashboard
                </a>
                <a href="student-module?id=<%= module.getId() %>&action=content" class="btn btn-primary">
                    <i class="fas fa-play"></i>
                    Begin Journey
                </a>
            </div>
        </div>
    </div>
</body>
</html>