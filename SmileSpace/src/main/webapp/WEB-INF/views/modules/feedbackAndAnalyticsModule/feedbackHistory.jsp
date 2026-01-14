<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback History - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #F0D5B8;
        }
        .header h1 {
            color: #F0A548;
            font-size: 32px;
            margin: 0;
        }
        .btn {
            padding: 10px 20px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn:hover {
            background: #C77D2F;
        }
        .feedback-info {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 2px solid #F0D5B8;
        }
        .history-list {
            list-style: none;
            padding: 0;
        }
        .history-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 2px solid #F0D5B8;
            display: flex;
            gap: 15px;
        }
        .history-icon {
            width: 40px;
            height: 40px;
            background: #F0D5B8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #713C0B;
        }
        .history-content {
            flex: 1;
        }
        .history-action {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 5px;
        }
        .history-details {
            color: #A06A2F;
            margin-bottom: 5px;
        }
        .history-meta {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: #888;
        }
        .no-history {
            text-align: center;
            padding: 50px;
            color: #A06A2F;
        }
        .action-icon {
            margin-right: 8px;
        }
        .action-CREATE { color: #27AE60; }
        .action-UPDATE { color: #F39C12; }
        .action-REPLY { color: #3498DB; }
        .action-RESOLVE { color: #9B59B6; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-history"></i> Feedback History</h1>
            <a href="${pageContext.request.contextPath}/feedback/analytics" class="btn">
                <i class="fas fa-arrow-left"></i> Back to Analytics
            </a>
        </div>
        
        <div class="feedback-info">
            <h3>Feedback #${feedbackId}</h3>
            <p>Showing all activity for this feedback item</p>
        </div>
        
        <c:choose>
            <c:when test="${not empty history}">
                <ul class="history-list">
                    <c:forEach var="item" items="${history}">
                        <li class="history-item">
                            <div class="history-icon">
                                <c:choose>
                                    <c:when test="${item.action_type == 'CREATE'}">
                                        <i class="fas fa-plus action-CREATE"></i>
                                    </c:when>
                                    <c:when test="${item.action_type == 'UPDATE'}">
                                        <i class="fas fa-edit action-UPDATE"></i>
                                    </c:when>
                                    <c:when test="${item.action_type == 'REPLY'}">
                                        <i class="fas fa-reply action-REPLY"></i>
                                    </c:when>
                                    <c:when test="${item.action_type == 'RESOLVE'}">
                                        <i class="fas fa-check action-RESOLVE"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-history"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="history-content">
                                <div class="history-action">
                                    <span class="action-icon">
                                        <c:choose>
                                            <c:when test="${item.action_type == 'CREATE'}">📝</c:when>
                                            <c:when test="${item.action_type == 'UPDATE'}">✏️</c:when>
                                            <c:when test="${item.action_type == 'REPLY'}">💬</c:when>
                                            <c:when test="${item.action_type == 'RESOLVE'}">✅</c:when>
                                            <c:otherwise>📋</c:otherwise>
                                        </c:choose>
                                    </span>
                                    ${item.action_type}
                                </div>
                                <div class="history-details">
                                    ${item.action_details}
                                </div>
                                <div class="history-meta">
                                    <span>
                                        <c:if test="${not empty item.performed_by}">
                                            <i class="fas fa-user"></i> ${item.performed_by}
                                        </c:if>
                                    </span>
                                    <span>
                                        <i class="far fa-clock"></i> 
                                        <fmt:formatDate value="${item.performed_at}" pattern="dd MMM yyyy, HH:mm:ss" />
                                    </span>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <div class="no-history">
                    <i class="fas fa-history" style="font-size: 64px; opacity: 0.5; margin-bottom: 20px;"></i>
                    <h3>No history found</h3>
                    <p>No activity has been recorded for this feedback item yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>