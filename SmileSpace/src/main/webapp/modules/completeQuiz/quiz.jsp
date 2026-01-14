<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.Question" %>
<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    String moduleName = (String) request.getAttribute("moduleName");
    String moduleId = (String) request.getAttribute("moduleId");
    if (moduleId == null) moduleId = "LM001";
    
    // Calculate total questions
    int totalQuestionsCount = (questions != null) ? questions.size() : 0;
    
    // No need to get session again - it's implicit
    if (questions == null || questions.isEmpty()) {
        response.sendRedirect("quiz?action=start&moduleId=" + moduleId);
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz - <%= moduleName %> - SmileSpace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Preahvihear', sans-serif;
        }
        
        body {
            background-color: #FFF8E8;
            color: #6B4F36;
            min-height: 100vh;
            padding: 20px;
        }
        
        .header {
        background-color: #FFF3C8;
        padding: 15px 40px;
        border-bottom: 2px solid #E8D9B5;
        display: flex;
        justify-content: space-between;  /* This spreads items to left and right */
        align-items: center;
        width: 100%;
    }

    .home-link {
        text-decoration: none;
        color: #6B4F36;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: opacity 0.2s;
        margin-left: auto;  /* This pushes it to the right */
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
        
        .logo i {
            color: #F0A548;
            font-size: 22px;
        }
        
        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }
        
        .container {
            width: 90%;
            max-width: 1000px;
            margin: 80px auto 40px;
            text-align: left;
        }
        
        .quiz-header {
            margin-bottom: 30px;
        }
        
        .quiz-title {
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #6B4F36;
        }
        
        .quiz-subtitle {
            font-size: 20px;
            color: #CF8224;
            font-weight: 400;
            margin-bottom: 25px;
        }
        
        .quiz-card {
            background-color: #FFF3C8;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .warning-box {
            background-color: #FFE5E5;
            border: 2px solid #FFB3B3;
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .warning-text {
            color: #C53030;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 16px;
        }
        
        .question-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        
        .question-table th {
            background-color: #FFE8B4;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 18px;
            color: #6B4F36;
            border-bottom: 2px solid #E6C68D;
        }
        
        .question-table td {
            padding: 20px 15px;
            border-bottom: 1px solid #E6C68D;
            background-color: #FFF8E1;
        }
        
        .question-number {
            color: #CF8224;
            font-weight: bold;
            font-size: 20px;
            width: 50px;
            text-align: center;
        }
        
        .question-text {
            color: #6B4F36;
            font-size: 18px;
            line-height: 1.5;
        }
        
        .answer-options {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .option-label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            padding: 12px 25px;
            border-radius: 25px;
            transition: all 0.3s ease;
            border: 2px solid #E6C68D;
            background: white;
            min-width: 120px;
            justify-content: center;
            font-weight: 600;
        }
        
        .option-label:hover {
            background: #FFF3C8;
            border-color: #CF8224;
            transform: translateY(-2px);
        }
        
        .option-label.selected {
            background: #CF8224;
            color: white;
            border-color: #CF8224;
        }
        
        .option-radio {
            display: none;
        }
        
        .option-text {
            font-size: 16px;
        }
        
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            gap: 20px;
        }
        
        .btn {
            padding: 14px 32px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
            min-width: 150px;
            text-align: center;
        }
        
        .btn-secondary {
            background: #E6C68D;
            color: #6B4F36;
        }
        
        .btn-secondary:hover {
            background: #D4B57F;
            transform: translateY(-2px);
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
        }
        
        .btn-primary {
            background: #CF8224;
            color: white;
        }
        
        .btn-primary:hover {
            background: #B3711E;
            transform: translateY(-2px);
            box-shadow: 0px 4px 8px rgba(0,0,0,0.15);
        }
        
        @media (max-width: 768px) {
            .container {
                width: 95%;
                margin: 70px auto 30px;
            }
            
            .quiz-card {
                padding: 20px;
            }
            
            .question-table {
                display: block;
                overflow-x: auto;
            }
            
            .question-table th,
            .question-table td {
                display: block;
                width: 100%;
                text-align: center;
            }
            
            .question-table th {
                position: static;
            }
            
            .answer-options {
                flex-direction: column;
                gap: 10px;
                align-items: center;
            }
            
            .option-label {
                width: 80%;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .btn {
                width: 100%;
            }
            
            .quiz-title {
                font-size: 28px;
            }
            
            .quiz-subtitle {
                font-size: 18px;
            }
            
            .header {
                position: static;
                justify-content: flex-end;
                margin-bottom: 20px;
            }

            
        }
    </style>
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
        <form id="quizForm" action="quiz" method="post">
            <!-- Hidden input to store module ID -->
            <input type="hidden" name="moduleId" value="<%= moduleId %>">
            <input type="hidden" id="totalQuestionsHidden" value="<%= totalQuestionsCount %>">
            
            <div class="quiz-header">
                <h1 class="quiz-title"><%= moduleName %></h1>
                <p class="quiz-subtitle">Answer all questions carefully</p>
            </div>
            
            <div class="quiz-card">
                <div class="warning-box">
                    <div class="warning-text">
                        <span>⚠️</span>
                        All answers will be saved. Once submitted, you cannot change your answers.
                    </div>
                </div>
                
                <table class="question-table">
                    <thead>
                        <tr>
                            <th style="width: 50px;">#</th>
                            <th>Question</th>
                            <th style="width: 200px;">True</th>
                            <th style="width: 200px;">False</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (questions != null) {
                            for (Question question : questions) { %>
                            <tr>
                                <td class="question-number"><%= question.getId() %></td>
                                <td class="question-text"><%= question.getText() %></td>
                                <td>
                                    <label class="option-label" data-question-id="<%= question.getId() %>" data-answer="true">
                                        <input type="radio" name="q<%= question.getId() %>" value="true" class="option-radio">
                                        <span class="option-text">True</span>
                                    </label>
                                </td>
                                <td>
                                    <label class="option-label" data-question-id="<%= question.getId() %>" data-answer="false">
                                        <input type="radio" name="q<%= question.getId() %>" value="false" class="option-radio">
                                        <span class="option-text">False</span>
                                    </label>
                                </td>
                            </tr>
                        <%   }
                           } %>
                    </tbody>
                </table>
                
                <div class="action-buttons">
                    <a href="quiz?action=start&moduleId=<%= moduleId %>" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Submit Quiz</button>
                </div>
            </div>
        </form>
    </div>
    
    <script>
        // Get total questions from hidden input
        const totalQuestions = parseInt(document.getElementById('totalQuestionsHidden').value) || 0;
        
        // Add event listeners to all option labels
        document.addEventListener('DOMContentLoaded', function() {
            const optionLabels = document.querySelectorAll('.option-label');
            
            optionLabels.forEach(label => {
                // Handle label click
                label.addEventListener('click', function(e) {
                    // Get the question row
                    const questionRow = this.closest('tr');
                    
                    // Remove selected class from all options for this question
                    const allOptions = questionRow.querySelectorAll('.option-label');
                    allOptions.forEach(option => {
                        option.classList.remove('selected');
                    });
                    
                    // Add selected class to clicked option
                    this.classList.add('selected');
                    
                    // Check the radio button
                    const radio = this.querySelector('input[type="radio"]');
                    radio.checked = true;
                });
                
                // Handle radio button change (for accessibility)
                const radio = label.querySelector('input[type="radio"]');
                if (radio) {
                    radio.addEventListener('change', function() {
                        const parentLabel = this.closest('.option-label');
                        const questionRow = parentLabel.closest('tr');
                        const allOptions = questionRow.querySelectorAll('.option-label');
                        
                        allOptions.forEach(option => {
                            option.classList.remove('selected');
                        });
                        
                        parentLabel.classList.add('selected');
                    });
                }
            });
        });
        
        // Form submission validation
        document.getElementById('quizForm').addEventListener('submit', function(e) {
            // Count answered questions
            const answeredQuestions = new Set();
            const allRadios = document.querySelectorAll('.option-radio:checked');
            
            allRadios.forEach(radio => {
                const name = radio.getAttribute('name');
                if (name && name.startsWith('q')) {
                    answeredQuestions.add(name);
                }
            });
            
            if (answeredQuestions.size < totalQuestions) {
                e.preventDefault();
                const unanswered = totalQuestions - answeredQuestions.size;
                alert('Please answer all questions. You have ' + unanswered + ' unanswered question(s).');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>