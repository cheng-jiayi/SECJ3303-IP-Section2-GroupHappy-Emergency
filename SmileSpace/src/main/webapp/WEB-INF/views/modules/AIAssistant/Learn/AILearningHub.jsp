<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
    if (contextPath == null || contextPath.isEmpty() || "/".equals(contextPath)) {
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: 'Arial', sans-serif;
            color: #6B4F36;
            min-height: 100vh;
        }
        
        /* Header */
        .header {
            background: #FFF3C8;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(107, 79, 54, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .logo h1 {
            color: #D7923B;
            font-size: 32px;
            font-weight: bold;
        }
        .nav-buttons {
            display: flex;
            gap: 15px;
        }
        .nav-btn {
            background: #D7923B;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-weight: 500;
        }
        .nav-btn:hover {
            background: #CF8224;
            transform: translateY(-2px);
        }
        .nav-btn.secondary {
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
        }
        .nav-btn.secondary:hover {
            background: #FFF3C8;
        }
        
        /* Main Container */
        .learn-container {
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        /* Welcome Section */
        .welcome-section {
            background: linear-gradient(135deg, #FFF3C8, #FFE9A9);
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .welcome-content {
            display: flex;
            align-items: center;
            gap: 40px;
        }
        .welcome-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #D7923B, #CF8224);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
        }
        .welcome-text h2 {
            color: #D7923B;
            font-size: 36px;
            margin-bottom: 10px;
        }
        .welcome-text p {
            color: #8B7355;
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .search-bar {
            display: flex;
            gap: 10px;
            max-width: 600px;
            margin-top: 20px;
        }
        .search-input {
            flex: 1;
            padding: 12px 20px;
            border: 2px solid #E8D4B9;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        .search-input:focus {
            border-color: #D7923B;
        }
        .search-btn {
            padding: 12px 25px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
        }
        .search-btn:hover {
            background: #CF8224;
            transform: translateY(-2px);
        }
        
        /* Stats Section */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            background: #FFF3C8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            color: #D7923B;
            font-size: 24px;
        }
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #D7923B;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #8B7355;
            font-size: 14px;
        }
        
        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .filter-title {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .filter-row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        .filter-label {
            display: block;
            margin-bottom: 8px;
            color: #6B4F36;
            font-weight: 500;
        }
        .filter-select {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #E8D4B9;
            border-radius: 8px;
            background: white;
            color: #6B4F36;
            font-size: 14px;
            cursor: pointer;
            outline: none;
        }
        .filter-select:focus {
            border-color: #D7923B;
        }
        .filter-actions {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }
        .clear-btn {
            padding: 10px 20px;
            background: white;
            color: #8B7355;
            border: 2px solid #E8D4B9;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .clear-btn:hover {
            background: #f5f5f5;
        }
        .apply-btn {
            padding: 10px 20px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .apply-btn:hover {
            background: #CF8224;
        }
        
        /* Modules Grid */
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .module-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
        }
        .module-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        .module-header {
            padding: 20px;
            background: linear-gradient(135deg, #D7923B, #CF8224);
            color: white;
            position: relative;
        }
        .module-category {
            display: inline-block;
            padding: 4px 12px;
            background: rgba(255,255,255,0.2);
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            margin-right: 10px;
        }
        .module-level {
            display: inline-block;
            padding: 4px 12px;
            background: rgba(255,255,255,0.2);
            border-radius: 15px;
            font-size: 12px;
        }
        .module-icon {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 24px;
            opacity: 0.8;
        }
        .module-body {
            padding: 25px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .module-body h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 10px;
            line-height: 1.4;
        }
        .module-description {
            color: #8B7355;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 20px;
            flex: 1;
        }
        .module-meta {
            display: flex;
            gap: 15px;
            margin-top: auto;
            color: #8B7355;
            font-size: 12px;
        }
        .module-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .module-footer {
            padding: 20px;
            border-top: 1px solid #E8D4B9;
            display: flex;
            gap: 10px;
        }
        .btn-view, .btn-learn {
            flex: 1;
            padding: 10px;
            text-align: center;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        .btn-view {
            background: white;
            color: #D7923B;
            border: 2px solid #D7923B;
        }
        .btn-view:hover {
            background: #FFF3C8;
        }
        .btn-learn {
            background: #D7923B;
            color: white;
        }
        .btn-learn:hover {
            background: #CF8224;
        }
        
        /* Category Section */
        .category-section {
            margin-bottom: 40px;
        }
        .category-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .category-title {
            color: #D7923B;
            font-size: 24px;
        }
        .view-all {
            color: #D7923B;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        .view-all:hover {
            text-decoration: underline;
        }
        .category-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .category-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .category-card:hover {
            transform: translateY(-5px);
            text-decoration: none;
            color: inherit;
        }
        .category-icon {
            width: 70px;
            height: 70px;
            background: #FFF3C8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            color: #D7923B;
            font-size: 28px;
        }
        .category-card h4 {
            color: #D7923B;
            margin-bottom: 10px;
        }
        .category-count {
            color: #8B7355;
            font-size: 12px;
            display: block;
            margin-top: 5px;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .empty-icon {
            font-size: 48px;
            color: #E8D4B9;
            margin-bottom: 20px;
        }
        .empty-state h3 {
            color: #D7923B;
            margin-bottom: 10px;
        }
        .empty-state p {
            color: #8B7355;
            margin-bottom: 20px;
        }
        
        /* AI Assistant CTA */
        .ai-assistant-cta {
            background: linear-gradient(135deg, #4A90E2, #2C6FB7);
            border-radius: 15px;
            padding: 40px;
            margin-top: 40px;
            text-align: center;
            color: white;
        }
        .ai-assistant-cta h2 {
            font-size: 28px;
            margin-bottom: 15px;
        }
        .ai-assistant-cta p {
            margin-bottom: 25px;
            opacity: 0.9;
        }
        .cta-btn {
            display: inline-block;
            padding: 12px 30px;
            background: white;
            color: #4A90E2;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
        }
        .cta-btn:hover {
            background: #f0f0f0;
            transform: translateY(-2px);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .header {
                padding: 15px;
                flex-direction: column;
                gap: 15px;
            }
            .learn-container {
                padding: 15px;
            }
            .welcome-section {
                padding: 25px;
            }
            .welcome-content {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            .modules-grid {
                grid-template-columns: 1fr;
            }
            .filter-row {
                flex-direction: column;
            }
            .filter-group {
                min-width: 100%;
            }
            .module-footer {
                flex-direction: column;
            }
        }
        
        /* Loading Animation */
        .loading {
            text-align: center;
            padding: 40px;
            color: #8B7355;
        }
        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #D7923B;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="logo">
            <h1>SmileSpace</h1>
        </div>
        <div class="nav-buttons">
            <a href="<%= contextPath %>/ai/chat" class="nav-btn secondary">
                <i class="fas fa-robot"></i> AI Assistant
            </a>
            <a href="<%= contextPath %>/dashboard" class="nav-btn">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Main Container -->
    <div class="learn-container">

        <!-- Category Quick Access -->
        <div class="category-section">
            <div class="category-header">
                <h3 class="category-title">Browse by Category</h3>
            </div>
            <div class="category-cards">
                <c:forEach var="cat" items="${categories}">
                    <a href="<%= contextPath %>/ai/learn?category=${cat}" class="category-card">
                        <div class="category-icon">
                            <c:choose>
                                <c:when test="${cat == 'Stress'}"><i class="fas fa-brain"></i></c:when>
                                <c:when test="${cat == 'Anxiety'}"><i class="fas fa-hand-holding-heart"></i></c:when>
                                <c:when test="${cat == 'Mindfulness'}"><i class="fas fa-spa"></i></c:when>
                                <c:when test="${cat == 'Self-Esteem'}"><i class="fas fa-users"></i></c:when>
                                <c:when test="${cat == 'Sleep'}"><i class="fas fa-moon"></i></c:when>
                                <c:otherwise><i class="fas fa-book"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <h4>${cat}</h4>
                        <c:if test="${not empty stats.categoryStats}">
                            <span class="category-count">
                                ${stats.categoryStats[cat] != null ? stats.categoryStats[cat] : 0} modules
                            </span>
                        </c:if>
                    </a>
                </c:forEach>
            </div>
        </div>

        <!-- Learning Modules Grid -->
        <c:choose>
            <c:when test="${not empty modules && fn:length(modules) > 0}">
                <div class="category-header">
                    <h3 class="category-title">
                        <c:choose>
                            <c:when test="${not empty param.category && param.category != 'all'}">
                                ${param.category} Modules
                            </c:when>
                            <c:when test="${not empty param.level && param.level != 'all'}">
                                ${param.level} Level Modules
                            </c:when>
                            <c:when test="${not empty param.search}">
                                Search Results for "${param.search}"
                            </c:when>
                            <c:otherwise>
                                All Learning Modules
                            </c:otherwise>
                        </c:choose>
                        <span style="font-size: 14px; color: #8B7355; margin-left: 10px;">
                            (${fn:length(modules)} found)
                        </span>
                    </h3>
                </div>
                
                <div class="modules-grid">
                    <c:forEach var="module" items="${modules}">
                        <div class="module-card">
                            <div class="module-header" style="background: ${module.level == 'Beginner' ? 'linear-gradient(135deg, #4CAF50, #45a049)' : 
                                                              module.level == 'Intermediate' ? 'linear-gradient(135deg, #2196F3, #1976D2)' :
                                                              'linear-gradient(135deg, #D7923B, #CF8224)'}">
                                <span class="module-category">${module.category}</span>
                                <span class="module-level">${module.level}</span>
                                <i class="fas ${module.level == 'Beginner' ? 'fa-seedling' : 
                                               module.level == 'Intermediate' ? 'fa-chart-line' : 
                                               'fa-mountain'} module-icon"></i>
                            </div>
                            <div class="module-body">
                                <h3>${module.title}</h3>
                                <p class="module-description">
                                    ${module.description != null ? module.description : 'No description available.'}
                                </p>
                                <div class="module-meta">
                                    <span><i class="fas fa-clock"></i> ${module.estimatedDuration != null ? module.estimatedDuration : 'N/A'}</span>
                                    <span><i class="fas fa-eye"></i> ${module.views} views</span>
                                    <span><i class="fas fa-calendar"></i> ${module.lastUpdated}</span>
                                </div>
                            </div>
                            <div class="module-footer">
                                <a href="<%= contextPath %>/ai/learn/${module.id}/interactive?topic=1" class="btn-learn">
                                    <i class="fas fa-play"></i> Start Learning
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3>No Modules Found</h3>
                    <p>
                        <c:choose>
                            <c:when test="${not empty param.search}">
                                No modules match your search for "${param.search}". Try a different search term or browse by category.
                            </c:when>
                            <c:when test="${not empty param.category && param.category != 'all'}">
                                No modules found in the ${param.category} category. Try another category or check back later.
                            </c:when>
                            <c:when test="${not empty param.level && param.level != 'all'}">
                                No ${param.level.toLowerCase()} level modules found. Try another difficulty level.
                            </c:when>
                            <c:otherwise>
                                No learning modules available yet. Check back soon!
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="<%= contextPath %>/ai/learn" class="nav-btn secondary">
                        <i class="fas fa-redo"></i> View All Modules
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- AI Assistant CTA -->
        <div class="ai-assistant-cta">
            <h2>Need Personalized Guidance?</h2>
            <p>Our AI Assistant can create a custom learning path based on your goals and progress.</p>
            <a href="<%= contextPath %>/ai/chat" class="cta-btn">
                <i class="fas fa-robot"></i> Talk to AI Assistant
            </a>
        </div>
    </div>

    <script>
        // Auto-submit filter form when select changes
        document.addEventListener('DOMContentLoaded', function() {
            const filterSelects = document.querySelectorAll('.filter-select');
            filterSelects.forEach(select => {
                select.addEventListener('change', function() {
                    this.form.submit();
                });
            });
            
            // Add loading animation for module cards on click
            const moduleCards = document.querySelectorAll('.module-card');
            moduleCards.forEach(card => {
                card.addEventListener('click', function(e) {
                    // Only for the card itself, not buttons inside
                    if (!e.target.closest('.btn-view') && !e.target.closest('.btn-learn')) {
                        const btn = this.querySelector('.btn-learn');
                        if (btn) {
                            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
                            btn.style.opacity = '0.7';
                            btn.style.cursor = 'wait';
                        }
                    }
                });
            });
            
            // Animate stats on scroll
            const observerOptions = {
                threshold: 0.5,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animate');
                    }
                });
            }, observerOptions);
            
            document.querySelectorAll('.stat-card').forEach(card => {
                observer.observe(card);
            });
        });
        
        // Quick search function
        function quickSearch(keyword) {
            window.location.href = '<%= contextPath %>/ai/learn?search=' + encodeURIComponent(keyword);
        }
        
        // View all modules in category
        function viewCategory(category) {
            window.location.href = '<%= contextPath %>/ai/learn?category=' + encodeURIComponent(category);
        }
    </script>
</body>
</html>