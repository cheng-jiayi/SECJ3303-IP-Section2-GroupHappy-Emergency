<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.CounselingSession" %>
<%@ page import="smilespace.model.Student" %>
<%@ page import="smilespace.model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    CounselingSession sessionObj = (CounselingSession) request.getAttribute("session");
    Student student = (Student) request.getAttribute("student");
    
    if (sessionObj == null) {
        response.sendRedirect(request.getContextPath() + "/counseling?action=viewSessions");
        return;
    }
    
    // Format date
    String formattedDate = "";
    if (sessionObj.getScheduledDateTime() != null) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
        formattedDate = sessionObj.getScheduledDateTime().format(formatter);
    }
    
    // Format next session date if exists
    String nextSessionDate = "";
    if (sessionObj.getNextSessionSuggested() != null) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
        nextSessionDate = sessionObj.getNextSessionSuggested().format(formatter);
    }
    
    // Get user info
    User user = (User) session.getAttribute("user");
    String userRole = (user != null) ? user.getUserRole() : "";
    boolean isProfessional = "professional".equals(userRole);
    boolean isStudent = "student".equals(userRole);
    
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session Details - SmileSpace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #FFF8E8;
            font-family: 'Inter', sans-serif;
            color: #6B4F36;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .container {
            width: 90%;
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-family: 'Preahvihear', sans-serif;
            font-size: 20px;
            font-weight: bold;
            z-index: 100;
        }

        .home-link {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #6B4F36;
            transition: opacity 0.2s;
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }

        .details-icon {
            font-size: 80px;
            color: #D7923B;
            margin-bottom: 20px;
            text-align: center;
        }

        h1 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 36px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 15px;
            color: #6B4F36;
        }

        .subtitle {
            font-size: 18px;
            margin-bottom: 40px;
            text-align: center;
            font-weight: 400;
            color: #CF8224;
            line-height: 1.5;
        }

        .session-id {
            background: #FFF3C8;
            padding: 12px 25px;
            border-radius: 25px;
            display: inline-block;
            margin-bottom: 30px;
            font-weight: 600;
            color: #6B4F36;
            border: 2px solid #E8D4B9;
            font-family: 'Preahvihear', sans-serif;
            font-size: 16px;
            text-align: center;
            width: 100%;
            max-width: 300px;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            border: 1px solid #E8D4B9;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
        }

        .card h2 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 24px;
            color: #6B4F36;
            margin-top: 0;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid #D7923B;
            position: relative;
        }

        .card h2::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 60px;
            height: 3px;
            background: #CF8224;
        }

        .detail-row {
            display: flex;
            align-items: flex-start;
            padding: 15px 0;
            border-bottom: 1px solid #E8D4B9;
            transition: background-color 0.2s;
        }

        .detail-row:hover {
            background-color: #FFF9F0;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #7e5625;
            font-size: 16px;
            width: 250px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-label i {
            color: #D7923B;
            width: 20px;
            text-align: center;
        }

        .detail-value {
            color: #6B4F36;
            font-size: 16px;
            font-weight: 500;
            flex: 1;
            line-height: 1.5;
        }

        .mood-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .mood-tag {
            background: linear-gradient(135deg, #D7923B, #E8A447);
            color: white;
            padding: 6px 14px;
            border-radius: 15px;
            font-size: 13px;
            display: inline-block;
            font-weight: 500;
            box-shadow: 0 2px 5px rgba(215, 146, 59, 0.2);
            transition: all 0.3s;
        }

        .mood-tag:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(215, 146, 59, 0.3);
        }

        .meeting-link {
            background: linear-gradient(135deg, #3498DB, #5DADE2);
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            box-shadow: 0 3px 10px rgba(52, 152, 219, 0.2);
        }

        .meeting-link:hover {
            background: linear-gradient(135deg, #2980B9, #3498DB);
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .status-pending {
            background: linear-gradient(135deg, #FFF3CD, #FFEAA7);
            color: #856404;
            border: 1px solid #FFE8A6;
        }

        .status-scheduled {
            background: linear-gradient(135deg, #D1ECF1, #A9DFE8);
            color: #0C5460;
            border: 1px solid #A3E4F7;
        }

        .status-completed {
            background: linear-gradient(135deg, #D4EDDA, #A9DFBF);
            color: #155724;
            border: 1px solid #9FE6B3;
        }

        .status-cancelled {
            background: linear-gradient(135deg, #F8D7DA, #F5B7B1);
            color: #721C24;
            border: 1px solid #F5B7B1;
        }

        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            font-size: 15px;
            font-family: 'Preahvihear', sans-serif;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #D7923B, #E8A447);
            color: white;
            border: 1px solid #D7923B;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #C77D2F, #D7923B);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(215, 146, 59, 0.4);
            text-decoration: none;
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #8B7355, #A38B6D);
            color: white;
            border: 1px solid #8B7355;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #6B4F36, #8B7355);
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
            box-shadow: 0 6px 20px rgba(107, 79, 54, 0.3);
        }

        .student-info {
            background: linear-gradient(135deg, #FFF3C8, #FFEAA7);
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #E8D4B9;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(215, 146, 59, 0.1);
        }

        .student-info h3 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 22px;
            color: #6B4F36;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #D7923B;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .student-info h3 i {
            color: #D7923B;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            background: rgba(255, 255, 255, 0.7);
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #E8D4B9;
            transition: all 0.3s;
        }

        .info-item:hover {
            background: rgba(255, 255, 255, 0.9);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(215, 146, 59, 0.15);
        }

        .info-label {
            font-weight: 600;
            color: #7e5625;
            font-size: 14px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-label i {
            color: #D7923B;
            width: 16px;
            text-align: center;
        }

        .info-value {
            color: #6B4F36;
            font-size: 16px;
            font-weight: 500;
            line-height: 1.4;
        }

        .phone-link {
            color: #3498DB;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }

        .phone-link:hover {
            color: #2980B9;
            text-decoration: underline;
        }

        .empty-state {
            text-align: center;
            color: #8B7355;
            font-style: italic;
            background: rgba(255, 243, 200, 0.3);
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .detail-row {
                flex-direction: column;
                gap: 8px;
                padding: 12px 0;
            }
            
            .detail-label {
                width: 100%;
                font-size: 14px;
            }
            
            .detail-value {
                font-size: 14px;
                width: 100%;
            }
            
            .actions {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 300px;
                justify-content: center;
            }
            
            .container {
                width: 95%;
                margin-top: 20px;
            }
            
            h1 {
                font-size: 28px;
            }
            
            .subtitle {
                font-size: 16px;
            }
            
            .top-right {
                position: relative;
                right: auto;
                top: auto;
                margin-bottom: 20px;
                text-align: center;
                width: 100%;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .student-info {
                padding: 20px;
            }
        }

        @media (max-width: 480px) {
            .card {
                padding: 20px;
            }
            
            .details-icon {
                font-size: 60px;
            }
            
            h1 {
                font-size: 24px;
            }
            
            .session-id {
                padding: 10px 20px;
                font-size: 14px;
            }
            
            .student-info {
                padding: 15px;
            }
        }
    </style>
</head>
<body>

<div class="top-right">
    <a href="<%= contextPath %>/dashboard" class="home-link">
        <i class="fas fa-home"></i>
        SmileSpace 
    </a>
</div>

<div class="container">
    <div style="text-align: center;">
        <div class="details-icon">
            <i class="fas fa-calendar-alt"></i>
        </div>
        
        <h1>Session Details</h1>
        
        <div class="subtitle">
            View all details about your counseling session
        </div>

        <div class="session-id">
            Session ID: <%= sessionObj.getSessionId() %>
        </div>
    </div>

    <!-- Show student info for professionals -->
    <% if (isProfessional && student != null) { %>
    <div class="student-info">
        <h3><i class="fas fa-user-graduate"></i> Student Information</h3>
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label"><i class="fas fa-user"></i> Student Name</div>
                <div class="info-value"><%= student.getFullName() %></div>
            </div>
            <div class="info-item">
                <div class="info-label"><i class="fas fa-id-card"></i> Student ID</div>
                <div class="info-value"><%= student.getUserId() %></div>
            </div>
            <div class="info-item">
                <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
                <div class="info-value">
                    <% if (student.getEmail() != null && !student.getEmail().isEmpty()) { %>
                        <a href="mailto:<%= student.getEmail() %>" class="phone-link">
                            <i class="fas fa-envelope"></i> <%= student.getEmail() %>
                        </a>
                    <% } else { %>
                        Not available
                    <% } %>
                </div>
            </div>
            <div class="info-item">
                <div class="info-label"><i class="fas fa-phone"></i> Phone Number</div>
                <div class="info-value">
                    <% if (student.getPhone() != null && !student.getPhone().isEmpty()) { %>
                        <a href="tel:<%= student.getPhone() %>" class="phone-link">
                            <i class="fas fa-phone"></i> <%= student.getPhone() %>
                        </a>
                    <% } else { %>
                        Not available
                    <% } %>
                </div>
            </div>
            <% if (student.getFaculty() != null && !student.getFaculty().isEmpty()) { %>
            <div class="info-item">
                <div class="info-label"><i class="fas fa-graduation-cap"></i> Faculty</div>
                <div class="info-value"><%= student.getFaculty() %></div>
            </div>
            <% } %>
            <% if (student.getYear() > 0) { %>
            <div class="info-item">
                <div class="info-label"><i class="fas fa-calendar-alt"></i> Year</div>
                <div class="info-value">Year <%= student.getYear() %></div>
            </div>
            <% } %>
            <% if (student.getMatricNumber() != null && !student.getMatricNumber().isEmpty()) { %>
            <div class="info-item">
                <div class="info-label"><i class="fas fa-hashtag"></i> Matric Number</div>
                <div class="info-value"><%= student.getMatricNumber() %></div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- Session Information Card -->
    <div class="card">
        <h2><i class="fas fa-info-circle"></i> Session Information</h2>
        
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-comments"></i> Session Type</div>
            <div class="detail-value"><%= sessionObj.getSessionType() != null ? sessionObj.getSessionType() : "Not specified" %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-calendar-day"></i> Date & Time</div>
            <div class="detail-value"><%= formattedDate %></div>
        </div>
        
        <% if (sessionObj.getMeetingLocation() != null && !sessionObj.getMeetingLocation().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-map-marker-alt"></i> Meeting Location</div>
            <div class="detail-value"><%= sessionObj.getMeetingLocation() %></div>
        </div>
        <% } %>
        
        <% if (sessionObj.getMeetingLink() != null && !sessionObj.getMeetingLink().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-video"></i> Meeting Link</div>
            <div class="detail-value">
                <a href="<%= sessionObj.getMeetingLink() %>" target="_blank" class="meeting-link">
                    <i class="fas fa-video"></i> Join Video Meeting
                </a>
            </div>
        </div>
        <% } %>
        
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-smile"></i> Student's Reported Mood</div>
            <div class="detail-value">
                <% if (sessionObj.getCurrentMood() != null && !sessionObj.getCurrentMood().isEmpty()) { %>
                    <div class="mood-tags">
                        <% 
                            String[] moods = sessionObj.getCurrentMood().split(",");
                            for (String mood : moods) {
                                if (!mood.trim().isEmpty()) {
                        %>
                            <span class="mood-tag"><%= mood.trim() %></span>
                        <% 
                                }
                            }
                        %>
                    </div>
                <% } else { %>
                    <span class="empty-state">No mood recorded</span>
                <% } %>
            </div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-question-circle"></i> Reason for Session</div>
            <div class="detail-value"><%= sessionObj.getReason() != null ? sessionObj.getReason() : "Not specified" %></div>
        </div>
        
        <% if (sessionObj.getAdditionalNotes() != null && !sessionObj.getAdditionalNotes().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-sticky-note"></i> Additional Notes</div>
            <div class="detail-value"><%= sessionObj.getAdditionalNotes() %></div>
        </div>
        <% } %>
        
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-flag"></i> Status</div>
            <div class="detail-value">
                <%
                    String status = sessionObj.getStatus();
                    String statusClass = "status-pending";
                    if (status != null) {
                        if (status.equalsIgnoreCase("pending assignment")) {
                            statusClass = "status-pending";
                        } else if (status.equalsIgnoreCase("assigned") || status.equalsIgnoreCase("scheduled")) {
                            statusClass = "status-scheduled";
                        } else if (status.equalsIgnoreCase("completed")) {
                            statusClass = "status-completed";
                        } else if (status.equalsIgnoreCase("cancelled")) {
                            statusClass = "status-cancelled";
                        }
                    }
                %>
                <span class="status-badge <%= statusClass %>">
                    <i class="fas fa-<%= 
                        statusClass.contains("pending") ? "clock" : 
                        statusClass.contains("scheduled") ? "calendar-check" :
                        statusClass.contains("completed") ? "check-circle" : "times-circle" 
                    %>"></i>
                    <%= status != null ? status : "Pending" %>
                </span>
            </div>
        </div>
    </div>

    <!-- Session Documentation Section (only for completed sessions) -->
    <% if ("completed".equalsIgnoreCase(sessionObj.getStatus())) { %>
    <div class="card">
        <h2><i class="fas fa-file-medical"></i> Session Documentation</h2>
        
        <% if (sessionObj.getSessionSummary() != null && !sessionObj.getSessionSummary().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-file-alt"></i> Session Summary</div>
            <div class="detail-value"><%= sessionObj.getSessionSummary() %></div>
        </div>
        <% } %>
        
        <% if (sessionObj.getObservedMood() != null && !sessionObj.getObservedMood().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-eye"></i> Observed Mood</div>
            <div class="detail-value">
                <div class="mood-tags">
                    <% 
                        String[] observedMoods = sessionObj.getObservedMood().split(",");
                        for (String mood : observedMoods) {
                            if (!mood.trim().isEmpty()) {
                    %>
                        <span class="mood-tag"><%= mood.trim() %></span>
                    <% 
                            }
                        }
                    %>
                </div>
            </div>
        </div>
        <% } %>
        
        <% if (sessionObj.getProgressNotes() != null && !sessionObj.getProgressNotes().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-clipboard-list"></i> Progress Notes</div>
            <div class="detail-value"><%= sessionObj.getProgressNotes() %></div>
        </div>
        <% } %>
        
        <% if (sessionObj.getFollowUpActions() != null && !sessionObj.getFollowUpActions().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-tasks"></i> Follow-up Actions</div>
            <div class="detail-value"><%= sessionObj.getFollowUpActions() %></div>
        </div>
        <% } %>
        
        <% if (sessionObj.getNextSessionSuggested() != null) { %>
        <div class="detail-row">
            <div class="detail-label"><i class="fas fa-calendar-plus"></i> Next Session Suggested</div>
            <div class="detail-value">
                <i class="fas fa-calendar-check" style="color: #27AE60; margin-right: 8px;"></i>
                <%= nextSessionDate %>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- Action Buttons -->
    <div class="actions">
        <a href="<%= contextPath %>/counseling?action=viewSessions" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Sessions
        </a>
        
        <!-- Document Session button for professionals -->
        <% if (isProfessional && sessionObj.getCounselorId() != null && 
              ("assigned".equalsIgnoreCase(sessionObj.getStatus()) || "scheduled".equalsIgnoreCase(sessionObj.getStatus()))) { %>
        <a href="<%= contextPath %>/counseling?action=documentSession&sessionId=<%= sessionObj.getSessionId() %>" 
           class="btn btn-primary">
            <i class="fas fa-file-medical"></i> Document Session
        </a>
        <% } %>
        
        <!-- Update Location button for professionals -->
        <% if (isProfessional && sessionObj.getCounselorId() != null && 
              ("assigned".equalsIgnoreCase(sessionObj.getStatus()) || "scheduled".equalsIgnoreCase(sessionObj.getStatus())) &&
              "In Person".equalsIgnoreCase(sessionObj.getSessionType())) { %>
        <button type="button" class="btn btn-primary" onclick="showLocationForm()">
            <i class="fas fa-map-marker-alt"></i> Update Location
        </button>
        <% } %>
        
        <a href="<%= contextPath %>/dashboard" class="btn btn-secondary">
            <i class="fas fa-home"></i> Back to Dashboard
        </a>
    </div>
</div>

<!-- Location Update Modal -->
<div id="locationModal" class="modal-overlay">
    <div class="modal-content">
        <h3 style="margin-top: 0; margin-bottom: 20px; color: #6B4F36; font-family: 'Preahvihear', sans-serif;">
            <i class="fas fa-map-marker-alt"></i> Update Meeting Location
        </h3>
        <form id="locationForm" method="post" action="<%= contextPath %>/counseling">
            <input type="hidden" name="action" value="updateLocation">
            <input type="hidden" name="sessionId" value="<%= sessionObj.getSessionId() %>">
            
            <div style="margin-bottom: 20px;">
                <label for="meetingLocation" style="display: block; margin-bottom: 8px; font-weight: 600; color: #6B4F36;">
                    <i class="fas fa-map-pin"></i> Meeting Location
                </label>
                <input type="text" id="meetingLocation" name="meetingLocation" 
                       value="<%= sessionObj.getMeetingLocation() != null ? sessionObj.getMeetingLocation() : "" %>"
                       style="width: 100%; padding: 12px; border: 2px solid #E8D4B9; border-radius: 8px; font-size: 16px; transition: border-color 0.3s;"
                       placeholder="Enter meeting location (e.g., Counseling Center, Room 101)"
                       onfocus="this.style.borderColor='#D7923B'"
                       onblur="this.style.borderColor='#E8D4B9'">
            </div>
            
            <div style="display: flex; gap: 15px; justify-content: flex-end;">
                <button type="button" onclick="hideLocationForm()" 
                        style="padding: 12px 25px; border: 2px solid #8B7355; background: white; color: #8B7355; border-radius: 25px; font-weight: 600; cursor: pointer; transition: all 0.3s;">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button type="submit" 
                        style="padding: 12px 25px; background: linear-gradient(135deg, #D7923B, #E8A447); color: white; border: none; border-radius: 25px; font-weight: 600; cursor: pointer; transition: all 0.3s;">
                    <i class="fas fa-check"></i> Update Location
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function showLocationForm() {
        document.getElementById('locationModal').style.display = 'flex';
    }
    
    function hideLocationForm() {
        document.getElementById('locationModal').style.display = 'none';
    }
    
    // Close modal when clicking outside
    document.getElementById('locationModal').addEventListener('click', function(e) {
        if (e.target === this) {
            hideLocationForm();
        }
    });

    // Add keyboard support
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            hideLocationForm();
        }
    });

    // Animation for cards on load
    document.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.card, .student-info');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });
</script>
</body>
</html>