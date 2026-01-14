<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Analytics - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: #FBF6EA;
            color: #713C0B;
            font-family: 'Fredoka', sans-serif;
            padding-bottom: 40px;
            min-height: 100vh;
        }

        /* Header Styles */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
            text-decoration: none;
            cursor: pointer;
        }

        .logo:hover {
            color: #D7923B;
            text-decoration: none;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 20px;
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
            transition: all 0.3s ease;
        }
        
        .user-btn:hover {
            background: #C77D2F;
            transform: scale(1.05);
        }
        
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 220px;
            display: none;
            z-index: 1000;
            overflow: hidden;
        }
        
        .dropdown.show { 
            display: block; 
        }
        
        .user-info { 
            padding: 15px; 
            background: #FFF3C8; 
            border-bottom: 2px solid #E8D4B9; 
        }
        
        .user-name { 
            font-weight: bold; 
            font-size: 16px;
        }
        
        .user-role {
            background: #D7923B;
            color: white;
            padding: 4px 12px;
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
            transition: background 0.2s;
        }
        
        .menu-item:hover { 
            background: #FFF8E8; 
            text-decoration: none;
        }
        
        .menu-item.logout { 
            color: #E74C3C; 
        }

        /* Page Header */
        .page-header {
            padding: 30px 40px 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 { 
            color: #F0A548; 
            font-size: 36px; 
            font-weight: 700; 
            margin-bottom: 10px;
        }
        
        .page-title p { 
            font-size: 16px; 
            color: #A06A2F; 
            margin-bottom: 0;
        }

        /* Stats Cards */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stats-card {
            background: #FFFFFF;
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 2px solid transparent;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            border-color: #F0D5B8;
        }

        .stats-card h3 { 
            font-size: 16px; 
            font-weight: 600; 
            margin: 0 0 15px 0; 
            color: #6B4F36;
        }
        
        .stats-card p { 
            font-size: 32px; 
            font-weight: 700; 
            color: #713C0B; 
            margin: 0;
        }
        
        .stats-card .emoji { 
            font-size: 40px; 
            position: absolute; 
            top: 20px; 
            right: 20px; 
            opacity: 0.8;
        }
        
        .stats-card .stats-details {
            margin-top: 15px;
            font-size: 14px;
            color: #A06A2F;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .progress-bar {
            height: 6px;
            background: #F0D5B8;
            border-radius: 3px;
            margin-top: 8px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 3px;
            width: 0%; /* Start at 0, will be set by JavaScript */
            transition: width 0.5s ease-in-out;
        }

        /* Filters Section */
        .filter-section {
            background: #FFFFFF;
            padding: 25px;
            border-radius: 20px;
            margin-bottom: 30px;
            border: 2px solid #F0D5B8;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
        }

        .filter-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto auto;
            gap: 15px;
            align-items: end;
        }

        .filter-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #713C0B;
            font-size: 14px;
        }

        .filter-input, .filter-select {
            width: 100%;
            padding: 12px 15px;
            border-radius: 12px;
            border: 2px solid #E2D5C1;
            background: #FBF6EA;
            font-size: 14px;
            color: #713C0B;
            transition: all 0.3s ease;
        }

        .filter-input:focus, .filter-select:focus {
            outline: none;
            border-color: #D7923B;
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }

        .filter-btn {
            padding: 12px 25px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .filter-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
        }

        .clear-btn {
            padding: 12px 25px;
            background: #6B4F36;
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            white-space: nowrap;
        }

        .clear-btn:hover {
            background: #5A2F08;
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }

        /* Feedback List */
        .feedback-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 40px;
        }

        .feedback-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .feedback-count {
            font-size: 18px;
            color: #713C0B;
            font-weight: 600;
        }

        .export-btn {
            padding: 10px 20px;
            background: #27AE60;
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .export-btn:hover {
            background: #219653;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .feedback-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .feedback-card { 
            background: white; 
            border-radius: 18px; 
            border: 2px solid #F0D5B8; 
            padding: 25px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }

        .feedback-card:hover {
            border-color: #D7923B;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .feedback-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: flex-start; 
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 15px;
        } 

        .feedback-user {
            flex: 1;
            min-width: 250px;
        }

        .feedback-user strong { 
            font-size: 18px;
            color: #713C0B;
            display: block;
            margin-bottom: 5px;
        }

        .feedback-user small {
            color: #A06A2F;
            font-size: 13px;
        }

        .category-tag { 
            background: #FFEBC8; 
            padding: 6px 14px; 
            font-weight: 600; 
            border-radius: 15px; 
            margin-right: 10px;
            font-size: 13px;
            display: inline-block;
            margin-top: 8px;
        }

        .feedback-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
        }

        .sentiment-label {
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 15px;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .sentiment-positive { 
            background-color: #2ECC71; 
            color: white; 
        }
        
        .sentiment-neutral { 
            background-color: #F39C12; 
            color: white; 
        }
        
        .sentiment-negative { 
            background-color: #E74C3C; 
            color: white; 
        }

        .resolved-label {
            background-color: #BDF5C6;
            color: #27AE60;
            padding: 6px 14px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 13px;
            border: 1px solid #A0EFB4;
        }

        .feedback-message {
            margin: 15px 0;
            line-height: 1.6;
            color: #5D4037;
            padding: 15px;
            background: #FBF6EA;
            border-radius: 12px;
            border-left: 4px solid #D7923B;
        }

        .feedback-reply {
            background: #F0F9FF;
            padding: 20px;
            border-radius: 12px;
            margin-top: 15px;
            border-left: 4px solid #3498DB;
        }

        .reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .reply-header strong {
            color: #2980B9;
            font-size: 16px;
        }

        .reply-date {
            color: #7F8C8D;
            font-size: 13px;
        }

        .action-row { 
            margin-top: 20px; 
            display: flex; 
            gap: 10px; 
            flex-wrap: wrap;
        }

        .btn-reply, .btn-resolve, .btn-history {
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-reply { 
            background: #BDF5C6; 
            color: #27AE60; 
        }
        
        .btn-reply:hover {
            background: #A0EFB4;
            transform: translateY(-2px);
            text-decoration: none;
            color: #27AE60;
        }

        .btn-resolve { 
            background: #FFCE8A; 
            color: #D35400; 
        }
        
        .btn-resolve:hover {
            background: #F39C12;
            color: white;
            transform: translateY(-2px);
        }

        .btn-history { 
            background: #E3F2FD; 
            color: #2980B9;
        }
        
        .btn-history:hover {
            background: #BBDEFB;
            transform: translateY(-2px);
            text-decoration: none;
            color: #2980B9;
        }

        /* No Results */
        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #7F8C8D;
        }

        .no-results i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .no-results h3 {
            margin-bottom: 10px;
            color: #713C0B;
        }

        /* Success/Error Messages */
        .alert-message {
            max-width: 1400px;
            margin: 0 auto 20px;
            padding: 0 40px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #c3e6cb;
            margin-bottom: 20px;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #f5c6cb;
            margin-bottom: 20px;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .filter-row {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
            }
            
            .page-header, .feedback-container {
                padding: 0 20px;
            }
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .feedback-header {
                flex-direction: column;
            }
            
            .feedback-meta {
                justify-content: flex-start;
                width: 100%;
            }
            
            .stats-section {
                grid-template-columns: 1fr;
            }
            
            .stats-card {
                padding: 20px;
            }
            
            .nav-actions {
                gap: 10px;
            }
            
            .export-btn, .filter-btn, .clear-btn {
                padding: 10px 15px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="logo">SmileSpace</a>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/feedback/report?type=detailed" class="export-btn">
                <i class="fas fa-file-export"></i> Export Report
            </a>
            <div class="user-menu">
                <button class="user-btn" id="userBtn">
                    <i class="fas fa-user"></i>
                </button>
                <div class="dropdown" id="dropdown">
                    <div class="user-info">
                        <div class="user-name">${sessionScope.userFullName}</div>
                        <div class="user-role">${sessionScope.userRole}</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Alert Messages -->
    <div class="alert-message">
        <c:if test="${not empty success}">
            <div class="alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
    </div>

    <div class="page-header">
        <div class="page-title">
            <h1>Feedback Analytics Dashboard</h1>
            <p>Review, analyze and respond to student feedback. Total: ${not empty totalFeedback ? totalFeedback : 0} feedback submissions</p>
        </div>

        <!-- Stats Section -->
        <div class="stats-section">
            <div class="stats-card">
                <h3>Positive Feedback</h3>
                <div class="emoji">👍</div>
                <p>${not empty positiveCount ? positiveCount : 0}</p>
                <div class="stats-details">
                    <span>
                        <span class="percent-display" data-percent="${not empty positivePercent ? positivePercent : 0}">0</span>% of total
                    </span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" 
                         data-percent="${not empty positivePercent ? positivePercent : 0}" 
                         data-color="#2ECC71"></div>
                </div>
            </div>
            
            <div class="stats-card">
                <h3>Neutral Feedback</h3>
                <div class="emoji">➖</div>
                <p>${not empty neutralCount ? neutralCount : 0}</p>
                <div class="stats-details">
                    <span>
                        <span class="percent-display" data-percent="${not empty neutralPercent ? neutralPercent : 0}">0</span>% of total
                    </span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" 
                         data-percent="${not empty neutralPercent ? neutralPercent : 0}" 
                         data-color="#F39C12"></div>
                </div>
            </div>
            
            <div class="stats-card">
                <h3>Negative Feedback</h3>
                <div class="emoji">👎</div>
                <p>${not empty negativeCount ? negativeCount : 0}</p>
                <div class="stats-details">
                    <span>
                        <span class="percent-display" data-percent="${not empty negativePercent ? negativePercent : 0}">0</span>% of total
                    </span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" 
                         data-percent="${not empty negativePercent ? negativePercent : 0}" 
                         data-color="#E74C3C"></div>
                </div>
            </div>
            
            <div class="stats-card">
                <h3>Resolved Feedback</h3>
                <div class="emoji">✅</div>
                <p>${not empty resolvedCount ? resolvedCount : 0}</p>
                <div class="stats-details">
                    <span>
                        <span class="percent-display" data-percent="${not empty resolvedPercent ? resolvedPercent : 0}">0</span>% resolution rate
                    </span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" 
                         data-percent="${not empty resolvedPercent ? resolvedPercent : 0}" 
                         data-color="#27AE60"></div>
                </div>
            </div>
        </div>

        <!-- Filters Section -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/feedback/analytics" class="filter-form" id="filterForm">
                <div class="filter-row">
                    <div class="filter-group">
                        <label><i class="fas fa-search"></i> Search Feedback</label>
                        <input type="text" name="search" placeholder="Search by name, message..." 
                               class="filter-input" id="searchInput" value="${param.search}">
                    </div>
                    
                    <div class="filter-group">
                        <label><i class="fas fa-smile"></i> Sentiment</label>
                        <select name="sentiment" class="filter-select" id="sentimentSelect">
                            <option value="">All Sentiments</option>
                            <option value="Positive" ${param.sentiment == 'Positive' ? 'selected' : ''}>Positive</option>
                            <option value="Neutral" ${param.sentiment == 'Neutral' ? 'selected' : ''}>Neutral</option>
                            <option value="Negative" ${param.sentiment == 'Negative' ? 'selected' : ''}>Negative</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label><i class="fas fa-check-circle"></i> Status</label>
                        <select name="status" class="filter-select" id="statusSelect">
                            <option value="">All Status</option>
                            <option value="New" ${param.status == 'New' ? 'selected' : ''}>New</option>
                            <option value="Resolved" ${param.status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="filter-btn">
                        <i class="fas fa-filter"></i> Apply Filters
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/feedback/analytics" class="clear-btn">
                        <i class="fas fa-redo"></i> Clear
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Feedback List -->
    <div class="feedback-container">
        <div class="feedback-header-row">
            <div class="feedback-count">
                <i class="fas fa-comments"></i> 
                <c:choose>
                    <c:when test="${not empty feedbackList}">
                        Showing ${feedbackList.size()} feedback submissions
                    </c:when>
                    <c:otherwise>
                        Showing 0 feedback submissions
                    </c:otherwise>
                </c:choose>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/feedback/report?type=detailed" class="export-btn">
                    <i class="fas fa-chart-bar"></i> Detailed Analytics
                </a>
            </div>
        </div>

        <div class="feedback-list" id="feedbackListContainer">
            <c:choose>
                <c:when test="${empty feedbackList}">
                    <div class="no-results">
                        <i class="fas fa-inbox"></i>
                        <h3>No feedback found</h3>
                        <p>Try adjusting your search filters or check back later</p>
                        <a href="${pageContext.request.contextPath}/feedback/analytics" class="clear-btn mt-3">
                            <i class="fas fa-redo"></i> Clear Filters
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="feedback" items="${feedbackList}">
                        <div class="feedback-card" id="feedback-${feedback.id}">
                            <div class="feedback-header">
                                <div class="feedback-user">
                                    <strong>
                                        <c:choose>
                                            <c:when test="${not empty feedback.name and feedback.name != ''}">
                                                ${feedback.name}
                                            </c:when>
                                            <c:otherwise>
                                                Anonymous User
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <c:if test="${not empty feedback.userFullName}">
                                        <small><i class="fas fa-user-tag"></i> ${feedback.userFullName}</small>
                                    </c:if>
                                    <br>
                                    <span class="category-tag"><i class="fas fa-tag"></i> ${feedback.category}</span>
                                    <small style="color:#888;">
                                        <i class="far fa-clock"></i> 
                                        <fmt:formatDate value="${feedback.createdAt}" pattern="dd MMM yyyy, HH:mm" />
                                    </small>
                                </div>
                                <div class="feedback-meta">
                                    <c:choose>
                                        <c:when test="${not empty feedback.sentiment}">
                                            <span class="sentiment-label sentiment-${feedback.sentiment.toLowerCase()}">
                                                <i class="fas fa-${feedback.sentiment == 'Positive' ? 'smile' : feedback.sentiment == 'Negative' ? 'frown' : 'meh'}"></i>
                                                ${feedback.sentiment}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="sentiment-label sentiment-neutral">
                                                <i class="fas fa-meh"></i> Neutral
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${feedback.resolved}">
                                        <span class="resolved-label">
                                            <i class="fas fa-check-circle"></i> Resolved
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="feedback-message">
                                ${feedback.message}
                            </div>
                            
                            <c:if test="${not empty feedback.replyMessage}">
                                <div class="feedback-reply">
                                    <div class="reply-header">
                                        <strong><i class="fas fa-reply"></i> Admin Response</strong>
                                        <c:if test="${not empty feedback.replyDate}">
                                            <span class="reply-date">
                                                Replied: <fmt:formatDate value="${feedback.replyDate}" pattern="dd MMM yyyy, HH:mm" />
                                            </span>
                                        </c:if>
                                    </div>
                                    <p>${feedback.replyMessage}</p>
                                </div>
                            </c:if>
                            
                            <div class="action-row">
                                <a href="${pageContext.request.contextPath}/feedback/reply?id=${feedback.id}" class="btn-reply">
                                    <i class="fas fa-reply"></i> Reply
                                </a>
                                
                                <c:if test="${not feedback.resolved}">
                                    <form action="${pageContext.request.contextPath}/feedback/resolve" method="post" onsubmit="return confirm('Mark this feedback as resolved?')" style="display:inline;">
                                        <input type="hidden" name="feedbackId" value="${feedback.id}">
                                        <button type="submit" class="btn-resolve">
                                            <i class="fas fa-check"></i> Mark as Resolved
                                        </button>
                                    </form>
                                </c:if>
                                
                                <a href="${pageContext.request.contextPath}/feedback/report?type=history&id=${feedback.id}" class="btn-history">
                                    <i class="fas fa-history"></i> View History
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Pagination -->
        <c:if test="${not empty feedbackList and feedbackList.size() >= 10}">
            <div style="text-align: center; margin-top: 40px;">
                <nav>
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">Previous</a>
                        </li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>

    <script>
        // Set progress bar widths after page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Set widths for progress bars
            document.querySelectorAll('.progress-fill[data-percent]').forEach(function(element) {
                let percent = element.getAttribute('data-percent');
                let color = element.getAttribute('data-color') || '#2ECC71';
                
                // Ensure percent is a valid number
                percent = parseFloat(percent) || 0;
                
                // Set the style safely
                element.style.width = percent + '%';
                element.style.background = color;
            });
            
            // Update percentage displays
            document.querySelectorAll('.percent-display[data-percent]').forEach(function(element) {
                let percent = element.getAttribute('data-percent');
                percent = parseFloat(percent) || 0;
                element.textContent = Math.round(percent); // Round to nearest integer
            });
            
            // Animate progress bars after a short delay
            setTimeout(function() {
                document.querySelectorAll('.progress-fill').forEach(function(element) {
                    element.style.transition = 'width 1s ease-in-out';
                });
            }, 100);
        });

        // User dropdown
        const userBtn = document.getElementById('userBtn');
        const dropdown = document.getElementById('dropdown');
        
        if (userBtn && dropdown) {
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
        }

        // Form submission
        const filterForm = document.getElementById('filterForm');
        if (filterForm) {
            filterForm.addEventListener('submit', function(e) {
                // Get form values
                const search = document.getElementById('searchInput').value;
                const sentiment = document.getElementById('sentimentSelect').value;
                const status = document.getElementById('statusSelect').value;
                
                // Build URL
                let url = '${pageContext.request.contextPath}/feedback/analytics?';
                const params = [];
                
                if (search) params.push('search=' + encodeURIComponent(search));
                if (sentiment) params.push('sentiment=' + encodeURIComponent(sentiment));
                if (status) params.push('status=' + encodeURIComponent(status));
                
                if (params.length > 0) {
                    url += params.join('&');
                }
                
                // Navigate to the filtered URL
                window.location.href = url;
                e.preventDefault();
            });
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-success, .alert-error');
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s ease-out';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 500);
            });
        }, 5000);
        
        // Confirm before marking as resolved
        document.querySelectorAll('form[action*="feedback/resolve"]').forEach(function(form) {
            form.addEventListener('submit', function(e) {
                if (!confirm('Are you sure you want to mark this feedback as resolved?')) {
                    e.preventDefault();
                }
            });
        });
    </script>

</body>
</html>