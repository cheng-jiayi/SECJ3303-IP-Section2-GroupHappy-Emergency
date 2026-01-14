<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.QuizResult" %>
<%@ page import="smilespace.model.Question" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.net.URLEncoder" %>
<%
    QuizResult result = (QuizResult) request.getAttribute("quizResult");
    String moduleName = result != null ? result.getModuleName() : "Quiz";
    String moduleId = result != null ? result.getModuleId() : "LM001";
    int score = result != null ? result.getScore() : 0;
    int total = result != null ? result.getTotalQuestions() : 0;
    int percentage = total > 0 ? (score * 100) / total : 0;
    
    // Determine result category and message
    String resultCategory = "";
    String resultMessage = "";
    String resultIcon = "";
    
    if (percentage >= 80) {
        resultCategory = "excellent";
        resultMessage = "Excellent! You have a strong understanding of this module.";
        resultIcon = "🏆";
    } else if (percentage >= 60) {
        resultCategory = "good";
        resultMessage = "Good job! You understand the basics well.";
        resultIcon = "👍";
    } else {
        resultCategory = "improve";
        resultMessage = "Keep learning! Review the module to improve your understanding.";
        resultIcon = "📚";
    }
    
    // Get module category from database
    smilespace.dao.LearningModuleDAO moduleDAO = new smilespace.dao.LearningModuleDAO();
    smilespace.model.LearningModule module = moduleDAO.findById(moduleId);
    String category = module != null ? module.getCategory() : "General";
    
    // URL encode the category for the link
    String encodedCategory = URLEncoder.encode(category, "UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Result - <%= moduleName %> - smilespace</title>
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
        
        .result-container {
            background-color: white;
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 800px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            border: 1px solid #E8D9B5;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
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
        }
        
        .score-display {
            text-align: center;
            margin: 30px 0;
        }
        
        .score-circle {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: linear-gradient(135deg, #CF8224 0%, #E8A95E 100%);
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            font-weight: bold;
            box-shadow: 0 8px 20px rgba(207, 130, 36, 0.3);
        }
        
        .score-number {
            font-size: 52px;
            line-height: 1;
            font-weight: 700;
        }
        
        .score-total {
            font-size: 22px;
            opacity: 0.9;
            font-weight: 500;
        }
        
        .percentage {
            font-size: 28px;
            color: #6B4F36;
            margin-top: 20px;
            font-weight: 700;
        }
        
        .result-category {
            text-align: center;
            margin: 25px 0;
            font-size: 20px;
            color: #CF8224;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .result-message {
            text-align: center;
            margin: 20px 0;
            font-size: 18px;
            color: #8D735B;
            line-height: 1.6;
            padding: 20px;
            background-color: #FFFDF6;
            border-radius: 12px;
            border-left: 4px solid #CF8224;
        }
        
        .questions-review {
            margin-top: 40px;
        }
        
        .review-title {
            color: #6B4F36;
            font-size: 22px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #E8D9B5;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .question-item {
            background-color: #FFFDF6;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #E8D9B5;
            transition: all 0.3s ease;
        }
        
        .question-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        .question-item.correct {
            border-left-color: #4CAF50;
            background-color: #F1F8E9;
        }
        
        .question-item.incorrect {
            border-left-color: #F44336;
            background-color: #FFEBEE;
        }
        
        .question-text {
            color: #6B4F36;
            font-size: 16px;
            margin-bottom: 15px;
            font-weight: 500;
            line-height: 1.5;
        }
        
        .answer-info {
            display: flex;
            gap: 30px;
            font-size: 14px;
            flex-wrap: wrap;
        }
        
        .correct-answer {
            color: #4CAF50;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .user-answer {
            color: #8D735B;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .user-answer.correct {
            color: #4CAF50;
            font-weight: 600;
        }
        
        .user-answer.incorrect {
            color: #F44336;
            font-weight: 600;
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
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-width: 180px;
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
        
        .score-breakdown {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
        }
        
        .breakdown-item {
            text-align: center;
        }
        
        .breakdown-value {
            font-size: 24px;
            font-weight: 700;
            color: #6B4F36;
        }
        
        .breakdown-label {
            font-size: 14px;
            color: #8D735B;
            margin-top: 5px;
        }
        
        @media (max-width: 768px) {
            .result-container {
                padding: 25px;
            }
            
            .answer-info {
                flex-direction: column;
                gap: 10px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .score-breakdown {
                flex-direction: column;
                gap: 15px;
            }
            
            .score-circle {
                width: 150px;
                height: 150px;
            }
            
            .score-number {
                font-size: 42px;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="result-container">
        <div class="header">
            <h1 class="module-title"><%= moduleName %></h1>
            <div class="module-badge"><%= moduleId %> - <%= category %> Module</div>
            <p class="module-subtitle">Quiz Completed!</p>
        </div>
        
        <div class="score-display">
            <div class="score-circle">
                <div class="score-number"><%= score %></div>
                <div class="score-total">out of <%= total %></div>
            </div>
            <div class="percentage"><%= percentage %>%</div>
            
            <div class="result-category">
                <span><%= resultIcon %></span>
                <span><%= resultCategory.toUpperCase() %>!</span>
            </div>
            
            <div class="result-message">
                <%= resultMessage %>
            </div>
            
            <div class="score-breakdown">
                <div class="breakdown-item">
                    <div class="breakdown-value"><%= score %></div>
                    <div class="breakdown-label">Correct Answers</div>
                </div>
                <div class="breakdown-item">
                    <div class="breakdown-value"><%= total - score %></div>
                    <div class="breakdown-label">Incorrect Answers</div>
                </div>
                <div class="breakdown-item">
                    <div class="breakdown-value"><%= total %></div>
                    <div class="breakdown-label">Total Questions</div>
                </div>
            </div>
        </div>
        
        <% if (result != null && result.getQuestions() != null) { %>
        <div class="questions-review">
            <h3 class="review-title">
                <i class="fas fa-clipboard-check"></i>
                Review Your Answers
            </h3>
            
            <%
                Map<Integer, Boolean> userAnswers = result.getUserAnswers();
                int questionIndex = 0;
                for (Question question : result.getQuestions()) {
                    questionIndex++;
                    // Get the question ID as Object and handle both String and Integer
                    Object questionIdObj = question.getId();
                    Integer questionId = null;
                    
                    if (questionIdObj instanceof Integer) {
                        questionId = (Integer) questionIdObj;
                    } else if (questionIdObj instanceof String) {
                        try {
                            questionId = Integer.parseInt((String) questionIdObj);
                        } catch (NumberFormatException e) {
                            questionId = questionIndex;
                        }
                    } else if (questionIdObj instanceof Long) {
                        questionId = ((Long) questionIdObj).intValue();
                    }
                    
                    // Use the parsed ID or fallback to index
                    int displayId = (questionId != null) ? questionId : questionIndex;
                    Boolean userAnswer = userAnswers.get(displayId);
                    boolean isCorrect = userAnswer != null && userAnswer == question.isTrue();
            %>
            <div class="question-item <%= isCorrect ? "correct" : "incorrect" %>">
                <div class="question-text">
                    <strong>Q<%= questionIndex %>.</strong> <%= question.getText() %>
                </div>
                <div class="answer-info">
                    <div class="correct-answer">
                        <i class="fas fa-check-circle"></i>
                        <span>Correct Answer: <strong><%= question.isTrue() ? "True" : "False" %></strong></span>
                    </div>
                    <% if (userAnswer != null) { %>
                    <div class="user-answer <%= isCorrect ? "correct" : "incorrect" %>">
                        <% if (isCorrect) { %>
                            <i class="fas fa-check-circle"></i>
                        <% } else { %>
                            <i class="fas fa-times-circle"></i>
                        <% } %>
                        <span>Your Answer: <strong><%= userAnswer ? "True" : "False" %></strong></span>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
        
        <div class="action-buttons">
            <a href="quiz-dashboard?category=<%= encodedCategory %>" class="btn btn-secondary">
                <i class="fas fa-th-large"></i>
                Back to Dashboard
            </a>
            <a href="student-module?id=<%= moduleId %>" class="btn btn-primary">
                <i class="fas fa-book-open"></i>
                Review Module
            </a>
        </div>
    </div>
</body>
</html>