<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // Check if user is logged in and is a student
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null || !"student".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Peer Support Forum - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
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
        }
        .logo h1 {
            color: #D7923B;
            font-size: 32px;
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
        }
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 200px;
            display: none;
            z-index: 1000;
        }
        .dropdown.show { display: block; }
        .user-info {
            padding: 15px;
            background: #FFF3C8;
            border-bottom: 2px solid #E8D4B9;
        }
        .user-name { font-weight: bold; }
        .user-role {
            background: #D7923B;
            color: white;
            padding: 3px 10px;
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
        }
        .menu-item:hover { background: #FFF8E8; }
        .menu-item.logout { color: #E74C3C; }
        
        /* Container */
        .container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        /* Welcome Section */
        .welcome {
            margin-bottom: 40px;
            text-align: center;
        }
        .welcome h2 {
            color: #D7923B;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .welcome p {
            color: #8B7355;
            font-size: 16px;
        }
        
        /* Forum Layout */
        .forum-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        /* Create Post Card */
        .create-post-card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border: 2px solid #E8D4B9;
        }
        
        .create-post-card h3 {
            color: #D7923B;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .post-form textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-family: Arial, sans-serif;
            font-size: 16px;
            resize: vertical;
            min-height: 120px;
            margin-bottom: 15px;
            background: white;
        }
        
        .post-form textarea:focus {
            outline: none;
            border-color: #D7923B;
        }
        
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #D7923B;
            cursor: pointer;
        }
        
        .btn-post {
            background: #D7923B;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        
        .btn-post:hover {
            background: #CF8224;
            transform: translateY(-2px);
        }
        
        /* Posts Container */
        .posts-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .posts-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #E8D4B9;
        }
        
        .posts-header h2 {
            color: #D7923B;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Post Item */
        .post-item {
            background: #FFF8E8;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border: 2px solid #E8D4B9;
            transition: all 0.3s;
        }
        
        .post-item:hover {
            box-shadow: 0 8px 20px rgba(107, 79, 54, 0.15);
        }
        
        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #E8D4B9;
        }
        
        .post-author {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .author-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #D7923B;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 20px;
        }
        
        .author-details {
            display: flex;
            flex-direction: column;
        }
        
        .author-name {
            font-weight: bold;
            color: #6B4F36;
            font-size: 16px;
        }
        
        .post-time {
            font-size: 14px;
            color: #8B7355;
        }
        
        .post-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
            border: 1px solid;
            background: white;
            transition: all 0.2s;
        }
        
        .btn-edit {
            color: #3498DB;
            border-color: #3498DB;
        }
        
        .btn-edit:hover {
            background: #3498DB;
            color: white;
        }
        
        .btn-delete {
            color: #E74C3C;
            border-color: #E74C3C;
        }
        
        .btn-delete:hover {
            background: #E74C3C;
            color: white;
        }
        
        /* Post Content */
        .post-content {
            font-size: 16px;
            line-height: 1.6;
            color: #6B4F36;
            margin-bottom: 25px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            border-left: 4px solid #D7923B;
            white-space: pre-wrap;
        }
        
        /* Reply Form */
        .reply-form {
            background: #FFF3C8;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            margin-bottom: 25px;
        }
        
        .reply-form textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #E8D4B9;
            border-radius: 8px;
            font-family: Arial, sans-serif;
            font-size: 15px;
            resize: vertical;
            min-height: 80px;
            margin-bottom: 10px;
            background: white;
        }
        
        .reply-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .btn-reply {
            background: #27AE60;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s;
        }
        
        .btn-reply:hover {
            background: #219653;
        }
        
        /* Replies Section */
        .replies-section {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #E8D4B9;
        }
        
        .replies-header {
            color: #D7923B;
            font-size: 18px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .reply-item {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid #E8D4B9;
            transition: all 0.3s;
        }
        
        .reply-item:hover {
            border-color: #D7923B;
            background: #FFFEF5;
        }
        
        .reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .reply-author {
            font-weight: bold;
            color: #6B4F36;
            font-size: 15px;
        }
        
        .reply-time {
            font-size: 13px;
            color: #8B7355;
        }
        
        .reply-content {
            font-size: 15px;
            line-height: 1.5;
            color: #6B4F36;
            white-space: pre-wrap;
            padding: 10px;
            background: #FFF8E8;
            border-radius: 8px;
        }
        
        /* Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .sidebar-card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border: 2px solid #E8D4B9;
        }
        
        .sidebar-card h3 {
            color: #D7923B;
            font-size: 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .community-guidelines {
            list-style: none;
        }
        
        .community-guidelines li {
            padding: 10px 0;
            border-bottom: 1px solid #E8D4B9;
            color: #6B4F36;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .community-guidelines li:last-child {
            border-bottom: none;
        }
        
        .community-guidelines i {
            color: #27AE60;
            margin-top: 3px;
        }
        
        .user-stats {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .stat-item-sidebar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 15px;
            background: #FFF8E8;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .stat-item-sidebar:hover {
            background: #E8D4B9;
        }
        
        .stat-label-sidebar {
            color: #6B4F36;
            font-weight: 500;
        }
        
        .stat-value-sidebar {
            font-weight: bold;
            color: #D7923B;
        }
        
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }
        
        .modal-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 2px solid #D7923B;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .modal-header h3 {
            color: #D7923B;
            font-size: 20px;
        }
        
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            color: #E74C3C;
            cursor: pointer;
        }
        
        .modal-body textarea {
            width: 100%;
            padding: 15px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-family: Arial, sans-serif;
            font-size: 16px;
            resize: vertical;
            min-height: 150px;
            margin-bottom: 20px;
            background: #FFF8E8;
        }
        
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }
        
        .btn-save {
            background: #27AE60;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-save:hover {
            background: #219653;
        }
        
        .btn-cancel {
            background: #8B7355;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-cancel:hover {
            background: #6B4F36;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #8B7355;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #E8D4B9;
        }
        
        .empty-state h3 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #D7923B;
        }
        
        .empty-state p {
            font-size: 16px;
            line-height: 1.6;
            max-width: 500px;
            margin: 0 auto 30px;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .forum-container {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            
            .post-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .post-actions {
                width: 100%;
                justify-content: flex-end;
            }
            
            .form-options {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
        }
        
        @media (max-width: 480px) {
            .header {
                padding: 15px 20px;
            }
            
            .logo h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="logo">
            <h1>SmileSpace</h1>
        </div>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
            <div class="dropdown" id="dropdown">
                <div class="user-info">
                    <div class="user-name"><%= userFullName %></div>
                    <div class="user-role">Student</div>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                    <i class="fas fa-user-edit"></i> Manage Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="welcome">
            <h2>Peer Support Forum</h2>
            <p>Share your thoughts, ask questions, and support each other</p>
        </div>

        <div class="forum-container">
            <!-- Main Content -->
            <div class="main-content">
                <!-- Create Post -->
                <div class="create-post-card">
                    <h3><i class="fas fa-edit"></i> Create New Post</h3>
                    <form action="${pageContext.request.contextPath}/forum/post" method="post" class="post-form">
                        <textarea name="content" placeholder="What's on your mind? Share your thoughts, ask for advice, or offer support to others..." required></textarea>
                        <div class="form-options">
                            <div class="checkbox-group">
                                <input type="checkbox" id="anonymousPost" name="anonymous">
                                <label for="anonymousPost">Post Anonymously</label>
                            </div>
                            <button type="submit" class="btn-post">
                                <i class="fas fa-paper-plane"></i> Publish Post
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Posts Container -->
                <div class="posts-container">
                    <div class="posts-header">
                        <h2><i class="fas fa-comments"></i> Community Posts</h2>
                    </div>

                    <c:choose>
                        <c:when test="${empty posts}">
                            <div class="empty-state">
                                <i class="fas fa-comments"></i>
                                <h3>No posts yet</h3>
                                <p>Be the first to start a conversation! Share your thoughts, ask questions, or offer support to others in the community.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="post" items="${posts}">
                                <div class="post-item" id="post-${post.postId}">
                                    <!-- Post Header -->
                                    <div class="post-header">
                                        <div class="post-author">
                                            <div class="author-avatar">
                                                <c:choose>
                                                    <c:when test="${post.anonymous}">
                                                        <i class="fas fa-user-secret"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:toUpperCase(fn:substring(post.user.fullName, 0, 1))}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="author-details">
                                                <div class="author-name">
                                                    <c:choose>
                                                        <c:when test="${post.anonymous}">Anonymous</c:when>
                                                        <c:otherwise>${fn:escapeXml(post.user.fullName)}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="post-time">
                                                    <i class="far fa-clock"></i> ${post.createdAt}
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${user != null && user.userId == post.user.userId}">
                                            <div class="post-actions">
                                                <button class="btn-action btn-edit edit-post-btn" 
                                                        data-type="post" 
                                                        data-id="${post.postId}" 
                                                        data-content="${fn:escapeXml(post.content)}">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <form action="${pageContext.request.contextPath}/forum/post/delete" method="post" style="display:inline;">
                                                    <input type="hidden" name="postId" value="${post.postId}">
                                                    <button type="submit" class="btn-action btn-delete" onclick="return confirm('Are you sure you want to delete this post?')">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Post Content -->
                                    <div class="post-content">
                                        ${fn:escapeXml(post.content)}
                                    </div>
                                    
                                    <!-- Reply Form -->
                                    <div class="reply-form">
                                        <form action="${pageContext.request.contextPath}/forum/reply" method="post">
                                            <input type="hidden" name="postId" value="${post.postId}">
                                            <textarea name="content" placeholder="Write a supportive reply..." required></textarea>
                                            <div class="reply-options">
                                                <div class="checkbox-group">
                                                    <input type="checkbox" id="anonymousReply-${post.postId}" name="anonymous">
                                                    <label for="anonymousReply-${post.postId}">Reply Anonymously</label>
                                                </div>
                                                <button type="submit" class="btn-reply">
                                                    <i class="fas fa-reply"></i> Post Reply
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <!-- REPLIES SECTION -->
                                    <c:if test="${not empty post.replies}">
                                        <div class="replies-section">
                                            <div class="replies-header">
                                                <i class="fas fa-reply"></i> Replies (${fn:length(post.replies)})
                                            </div>
                                            <c:forEach var="reply" items="${post.replies}">
                                                <div class="reply-item">
                                                    <div class="reply-header">
                                                        <div class="reply-author">
                                                            <c:choose>
                                                                <c:when test="${reply.anonymous}">
                                                                    <i class="fas fa-user-secret"></i> Anonymous
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-user"></i> ${fn:escapeXml(reply.user.fullName)}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="reply-time">
                                                            <i class="far fa-clock"></i> ${reply.createdAt}
                                                        </div>
                                                    </div>
                                                    <div class="reply-content">
                                                        ${fn:escapeXml(reply.content)}
                                                    </div>
                                                    <c:if test="${user != null && user.userId == reply.user.userId}">
                                                        <div style="margin-top: 10px; display: flex; gap: 8px; justify-content: flex-end;">
                                                            <button class="btn-action btn-edit edit-reply-btn" 
                                                                    data-type="reply" 
                                                                    data-id="${reply.replyId}" 
                                                                    data-content="${fn:escapeXml(reply.content)}"
                                                                    style="font-size: 12px; padding: 4px 8px;">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/forum/reply/delete" method="post" style="display:inline;">
                                                                <input type="hidden" name="replyId" value="${reply.replyId}">
                                                                <button type="submit" class="btn-action btn-delete" 
                                                                        onclick="return confirm('Are you sure you want to delete this reply?')"
                                                                        style="font-size: 12px; padding: 4px 8px;">
                                                                    <i class="fas fa-trash"></i> Delete
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <!-- Community Guidelines -->
                <div class="sidebar-card">
                    <h3><i class="fas fa-handshake"></i> Community Guidelines</h3>
                    <ul class="community-guidelines">
                        <li><i class="fas fa-check"></i> Be kind and respectful</li>
                        <li><i class="fas fa-check"></i> Maintain confidentiality</li>
                        <li><i class="fas fa-check"></i> Offer constructive support</li>
                        <li><i class="fas fa-check"></i> Share your experiences</li>
                        <li><i class="fas fa-check"></i> Report concerns to moderators</li>
                    </ul>
                </div>

                <!-- Your Activity -->
                <div class="sidebar-card">
                    <h3><i class="fas fa-chart-bar"></i> Your Activity</h3>
                    <div class="user-stats">
                        <c:set var="userPostCount" value="0" />
                        <c:forEach var="post" items="${posts}">
                            <c:if test="${user != null && user.userId == post.user.userId}">
                                <c:set var="userPostCount" value="${userPostCount + 1}" />
                            </c:if>
                        </c:forEach>
                        
                        <c:set var="userReplyCount" value="0" />
                        <c:forEach var="post" items="${posts}">
                            <c:forEach var="reply" items="${post.replies}">
                                <c:if test="${user != null && user.userId == reply.user.userId}">
                                    <c:set var="userReplyCount" value="${userReplyCount + 1}" />
                                </c:if>
                            </c:forEach>
                        </c:forEach>
                        
                        <div class="stat-item-sidebar">
                            <span class="stat-label-sidebar">Your Posts</span>
                            <span class="stat-value-sidebar">${userPostCount}</span>
                        </div>
                        <div class="stat-item-sidebar">
                            <span class="stat-label-sidebar">Your Replies</span>
                            <span class="stat-value-sidebar">${userReplyCount}</span>
                        </div>
                        <div class="stat-item-sidebar">
                            <span class="stat-label-sidebar">Support Given</span>
                            <span class="stat-value-sidebar">${userPostCount + userReplyCount}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Content</h3>
                <button class="close-btn" onclick="closeEditModal()">&times;</button>
            </div>
            <form id="editForm" method="post">
                <input type="hidden" id="editId" name="editId">
                <div class="modal-body">
                    <textarea id="editContent" name="content" required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn-save">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // User dropdown
        const userBtn = document.getElementById('userBtn');
        const dropdown = document.getElementById('dropdown');
        
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
        
        // Edit modal functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Handle edit button clicks
            document.addEventListener('click', function(e) {
                const editBtn = e.target.closest('.btn-edit');
                if (!editBtn) return;
                
                e.preventDefault();
                
                if (editBtn.classList.contains('edit-post-btn') || editBtn.classList.contains('edit-reply-btn')) {
                    const type = editBtn.dataset.type;
                    const id = editBtn.dataset.id;
                    const content = editBtn.dataset.content;
                    openEditModal(type, id, content);
                }
            });
            
            // Form validation
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const textarea = this.querySelector('textarea[name="content"]');
                    if (textarea && textarea.value.trim().length === 0) {
                        e.preventDefault();
                        alert('Please enter some content before posting.');
                        textarea.focus();
                    }
                });
            });
            
            // Auto-resize textareas
            const textareas = document.querySelectorAll('textarea');
            textareas.forEach(textarea => {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = (this.scrollHeight) + 'px';
                });
            });
        });
        
        function openEditModal(type, id, content) {
            const modal = document.getElementById('editModal');
            const form = document.getElementById('editForm');
            const contentTextarea = document.getElementById('editContent');
            const editIdInput = document.getElementById('editId');
            
            modal.style.display = 'flex';
            contentTextarea.value = content;
            
            // Set form action and input name based on type
            if (type === 'post') {
                form.action = '${pageContext.request.contextPath}/forum/post/edit';
                editIdInput.name = 'postId';
            } else {
                form.action = '${pageContext.request.contextPath}/forum/reply/edit';
                editIdInput.name = 'replyId';
            }
            editIdInput.value = id;
            
            // Focus on textarea
            setTimeout(() => {
                contentTextarea.focus();
                contentTextarea.select();
            }, 100);
        }
        
        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeEditModal();
            }
        });
        
        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                closeEditModal();
            }
        });
    </script>
</body>
</html>
