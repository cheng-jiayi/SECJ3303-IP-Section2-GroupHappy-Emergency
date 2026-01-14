<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String duration = (String) request.getAttribute("duration");
    String type = (String) request.getAttribute("type");
    String moduleName = (String) request.getAttribute("moduleName");
    String moduleId = (String) request.getAttribute("moduleId");
    if (moduleId == null) moduleId = "LM001";
    
    // Get module from session or request to get category
    // Note: 'session' is an implicit variable, don't redeclare it
    smilespace.model.LearningModule module = (smilespace.model.LearningModule) session.getAttribute("currentModule");
    if (module == null) {
        // Try to load module from database
        smilespace.dao.LearningModuleDAO moduleDAO = new smilespace.dao.LearningModuleDAO();
        module = moduleDAO.findById(moduleId);
    }
    String category = module != null ? module.getCategory() : "General";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Instructions - smilespace</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: #FFF8E8;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .quiz-container {
            background-color: white;
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 600px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            border: 1px solid #E8D9B5;
        }
        
        .header {
            background-color: #FFF3C8;
            padding: 15px 40px;
            border-bottom: 2px solid #E8D9B5;
            display: flex;
            justify-content: flex-end;  /* Changed from space-between to flex-end */
            align-items: center;
        }

        .home-link {
            text-decoration: none;  /* Remove underline */
            color: #F0A548;  /* Change color to match logo */
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
            /* Remove justify-content: flex-end and margin-left: auto */
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;  /* Ensure no underline on hover */
        }
        
        .module-title {
            color: #6B4F36;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .module-subtitle {
            color: #8D735B;
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .instruction-card {
            background-color: #FFFDF6;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #E8D9B5;
        }
        
        .instruction-title {
            color: #6B4F36;
            font-size: 22px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            padding-bottom: 15px;
            border-bottom: 2px solid #E8D9B5;
        }
        
        .instruction-list {
            list-style: none;
        }
        
        .instruction-list li {
            padding: 12px 0;
            color: #8D735B;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid #F0E9DD;
        }
        
        .instruction-list li:last-child {
            border-bottom: none;
        }
        
        .icon {
            font-size: 20px;
            width: 24px;
            text-align: center;
            color: #CF8224;
        }
        
        .tip-box {
            background: linear-gradient(135deg, #FFF9E6 0%, #FFEBB2 100%);
            border-radius: 12px;
            padding: 25px;
            margin: 25px 0;
            border-left: 4px solid #CF8224;
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
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 16px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
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
        
        .module-badge {
            display: inline-block;
            background-color: #FFF3C8;
            color: #CF8224;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-top: 10px;
        }
        
        @media (max-width: 768px) {
            .quiz-container {
                padding: 25px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .module-title {
                font-size: 24px;
            }
            
            .instruction-card {
                padding: 20px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="quiz-container">
        <div class="header">
            <h1 class="module-title"><%= moduleName %></h1>
            <div class="module-badge"><%= moduleId %> - <%= category %> Module</div>
            <p class="module-subtitle">Up next, you will take a short quiz to test what you've learned in the module.</p>
        </div>
        
        <div class="instruction-card">
            <h2 class="instruction-title">
                <i class="fas fa-file-alt"></i>
                Quiz Instruction
            </h2>
            <ul class="instruction-list">
                <li>
                    <span class="icon"><i class="far fa-clock"></i></span>
                    <span><strong>Duration:</strong> <%= duration %></span>
                </li>
                <li>
                    <span class="icon"><i class="fas fa-list-alt"></i></span>
                    <span><strong>Type:</strong> <%= type %></span>
                </li>
                <li>
                    <span class="icon"><i class="fas fa-book-reader"></i></span>
                    <span>Read each statement carefully and select whether it is True or False based on what you learned</span>
                </li>
                <li>
                    <span class="icon"><i class="fas fa-check-circle"></i></span>
                    <span>Click Submit after answering all questions</span>
                </li>
                <li>
                    <span class="icon"><i class="fas fa-exclamation-triangle"></i></span>
                    <span>All answers will be saved automatically. Once submitted, you cannot change your answers</span>
                </li>
            </ul>
        </div>
        
        <div class="tip-box">
            <div class="tip-title">
                <i class="fas fa-lightbulb"></i>
                Tip
            </div>
            <p>Take your time to recall what you've learned. Review the module content if needed before starting.</p>
        </div>
        
        <div class="action-buttons">
            <a href="student-module?id=<%= moduleId %>" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i>
                Go Back
            </a>
            <a href="quiz?action=take&moduleId=<%= moduleId %>" class="btn btn-primary">
                <i class="fas fa-play"></i>
                Start Quiz
            </a>
        </div>
    </div>
</body>
</html>