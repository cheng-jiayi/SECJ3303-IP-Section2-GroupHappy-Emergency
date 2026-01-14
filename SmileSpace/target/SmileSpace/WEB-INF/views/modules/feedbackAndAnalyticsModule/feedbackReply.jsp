<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String feedbackId = request.getAttribute("feedbackId") != null ? 
        request.getAttribute("feedbackId").toString() : "";
    String feedbackMessage = request.getAttribute("feedbackMessage") != null ? 
        (String) request.getAttribute("feedbackMessage") : "";
    String userName = request.getAttribute("userName") != null ? 
        (String) request.getAttribute("userName") : "Anonymous";
    String errorMessage = (String) request.getAttribute("error");
    
    // Check if user is admin/faculty
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null || (!userRole.equals("admin") && !userRole.equals("faculty"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reply to Feedback - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Fredoka', sans-serif; 
        }

        body {
            background: #FBF6EA;
            color: #713C0B;
            padding-bottom: 40px;
            min-height: 100vh;
        }

        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
            text-decoration: none;
        }

        .logo:hover {
            color: #D7923B;
        }

        .page-header {
            text-align: center;
            margin-top: 35px;
            margin-bottom: 30px;
        }

        .page-header h1 { 
            color: #F0A548; 
            font-size: 40px; 
            font-weight: 700; 
            margin-bottom: 10px;
        }
        
        .page-header p { 
            margin-top: 10px; 
            font-size: 18px; 
            color: #A06A2F; 
        }

        .container {
            width: 70%;
            margin: 0 auto;
        }

        .feedback-card {
            background: #FFFFFF;
            border-radius: 20px;
            border: 2px solid #F0D5B8;
            margin-bottom: 30px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .feedback-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #F0D5B8;
        }

        .feedback-header h3 {
            color: #713C0B;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .feedback-user {
            font-size: 16px;
            color: #A06A2F;
            margin-bottom: 5px;
        }

        .feedback-message {
            background: #FBF6EA;
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid #D7923B;
            margin: 20px 0;
            line-height: 1.6;
            white-space: pre-wrap;
        }

        .reply-form {
            background: #FFFFFF;
            border-radius: 20px;
            border: 2px solid #F0D5B8;
            padding: 30px;
        }

        label { 
            font-weight: 600; 
            display: block; 
            margin: 14px 0 6px; 
            color: #713C0B;
        }
        
        textarea {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            background: #F4F2FA;
            border: 2px solid #E2D5C1;
            font-size: 15px;
            height: 200px;
            resize: vertical;
            min-height: 120px;
        }
        
        textarea:focus {
            outline: none;
            border-color: #D7923B;
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .btn {
            padding: 14px 30px;
            border-radius: 12px;
            border: none;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-submit {
            background: #BDF5C6;
            color: #2C6B2F;
        }
        
        .btn-submit:hover {
            background: #A0EFB4;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background: #FFCE8A;
            color: #D35400;
        }
        
        .btn-cancel:hover {
            background: #F39C12;
            color: white;
            transform: translateY(-2px);
        }

        .error {
            color: #E74C3C;
            margin-top: 10px;
            font-size: 14px;
            padding: 10px;
            background: #FDEDED;
            border-radius: 8px;
            border-left: 4px solid #E74C3C;
            margin-bottom: 20px;
        }

        .back-link {
            margin-top: 30px;
            text-align: center;
        }

        .back-link a {
            color: #D7923B;
            text-decoration: none;
            font-weight: 600;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 992px) {
            .container {
                width: 90%;
            }
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

    <div class="top-nav">
        <a href="<%= request.getContextPath() %>/dashboard" class="logo">SmileSpace</a>
        <a href="<%= request.getContextPath() %>/feedback/analytics" class="btn-cancel">
            <i class="fas fa-arrow-left"></i> Back to Analytics
        </a>
    </div>

    <div class="page-header">
        <h1>Reply to Feedback</h1>
        <p>Send a response to user feedback</p>
    </div>

    <div class="container">
        <% if (errorMessage != null) { %>
            <div class="error">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <% } %>

        <div class="feedback-card">
            <div class="feedback-header">
                <h3><i class="fas fa-comment-dots"></i> Original Feedback</h3>
                <div class="feedback-user">
                    <strong>From:</strong> <%= userName %>
                </div>
                <div class="feedback-user">
                    <strong>Feedback ID:</strong> <%= feedbackId %>
                </div>
            </div>
            <div class="feedback-message">
                <%= feedbackMessage %>
            </div>
        </div>

        <form class="reply-form" method="POST" action="${pageContext.request.contextPath}/feedback/reply">
            <input type="hidden" name="feedbackId" value="<%= feedbackId %>">
            
            <label for="replyMessage">Your Response *</label>
            <textarea id="replyMessage" name="replyMessage" placeholder="Type your response here..." required></textarea>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-submit">
                    <i class="fas fa-paper-plane"></i> Send Response
                </button>
                <a href="<%= request.getContextPath() %>/feedback/analytics" class="btn btn-cancel">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>

        <div class="back-link">
            <a href="<%= request.getContextPath() %>/feedback/analytics">
                <i class="fas fa-arrow-left"></i> Return to Feedback Analytics
            </a>
        </div>
    </div>

    <script>
        // Character counter
        const textarea = document.getElementById('replyMessage');
        const charCounter = document.createElement('div');
        charCounter.style.cssText = 'text-align: right; font-size: 12px; color: #666; margin-top: 5px;';
        textarea.parentNode.insertBefore(charCounter, textarea.nextSibling);
        
        function updateCharCounter() {
            const length = textarea.value.length;
            charCounter.textContent = `${length} characters (minimum 10)`;
            charCounter.style.color = length < 10 ? '#E74C3C' : '#27AE60';
        }
        
        textarea.addEventListener('input', updateCharCounter);
        updateCharCounter(); // Initial call
        
        // Form validation
        const form = document.querySelector('form');
        form.addEventListener('submit', function(e) {
            const replyMessage = document.getElementById('replyMessage');
            if (replyMessage.value.trim().length < 10) {
                e.preventDefault();
                alert('Please provide a more detailed response (at least 10 characters)');
                replyMessage.focus();
            }
        });
        
        // Auto-focus on textarea when page loads
        document.addEventListener('DOMContentLoaded', function() {
            textarea.focus();
        });
    </script>

</body>
</html>