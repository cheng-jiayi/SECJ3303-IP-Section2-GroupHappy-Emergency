<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.CounselingSession" %>
<%@ page import="smilespace.model.Student" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    CounselingSession sessionObj = (CounselingSession) request.getAttribute("session");
    Student student = (Student) request.getAttribute("student");
    
    if (sessionObj == null || student == null) {
        response.sendRedirect("counseling?action=professionalSessions");
        return;
    }
    
    // Format dates
    String formattedSessionDate = "";
    if (sessionObj.getSessionDateTime() != null) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
        formattedSessionDate = sessionObj.getSessionDateTime().format(formatter);
    }
    
    String formattedDocumentedDate = "";
    if (sessionObj.getDocumentedDate() != null) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
        formattedDocumentedDate = sessionObj.getDocumentedDate().format(formatter);
    }
    
    // Check status
    boolean isCompleted = "Completed".equalsIgnoreCase(sessionObj.getStatus());
    boolean isCancelled = "Cancelled".equalsIgnoreCase(sessionObj.getStatus());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
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
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        .container {
            width: 90%;
            max-width: 800px;
            text-align: center;
            margin-top: 3%;
            margin-bottom: 5%;
        }

        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-family: 'Preahvihear', sans-serif;
            font-size: 20px;
            font-weight: bold;
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
            margin-bottom: 10px;
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

        .card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 30px 40px;
            margin-bottom: 25px;
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1);
            text-align: left;
        }

        .card h2 {
            font-size: 22px;
            color: #6B4F36;
            margin-top: 0;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E8D4B9;
            text-align: left;
            font-family: 'Preahvihear', sans-serif;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .detail-row {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #E8D4B9;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #7e5625;
            font-size: 15px;
            width: 240px;
            flex-shrink: 0;
        }

        .detail-value {
            color: #6B4F36;
            font-size: 15px;
            font-weight: 500;
            text-align: left;
            flex: 1;
            line-height: 1.5;
            display: flex;
            align-items: center;
        }

        .mood-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center; 
        }

        .mood-tag {
            background: #D7923B;
            color: white;
            padding: 6px 14px;
            border-radius: 15px;
            font-size: 13px;
            display: inline-block;
            font-weight: 500;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
        }

        .status-scheduled { 
            color: #27AE60; 
            background: #E8F6F3;
        }

        .status-completed { 
            color: #3498DB; 
            background: #E8F4F8;
        }

        .status-cancelled { 
            color: #E74C3C; 
            background: #FFE8E6;
        }
        
        .status-pending {
            color: #F39C12;
            background: #FEF9E7;
        }

        .risk-high {
            color: #E74C3C;
            font-weight: 600;
        }

        .risk-medium {
            color: #F39C12;
            font-weight: 600;
        }

        .risk-low {
            color: #27AE60;
            font-weight: 600;
        }

        .actions {
            margin-top: 40px;
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            font-size: 15px;
            font-family: 'Preahvihear', sans-serif;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }

        .primary-btn {
            background: #D7923B;
            color: white;
        }

        .primary-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(215, 146, 59, 0.4);
            text-decoration: none;
            color: white;
        }

        .secondary-btn {
            background: #8B7355;
            color: white;
        }

        .secondary-btn:hover {
            background: #6B4F36;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .danger-btn {
            background: #E74C3C;
            color: white;
        }

        .danger-btn:hover {
            background: #C0392B;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.4);
        }

        .back-btn {
            background: #8B7355;
            color: white;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            font-size: 15px;
            font-family: 'Preahvihear', sans-serif;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            background: #6B4F36;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .detail-row {
                flex-direction: column;
                align-items: flex-start;
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
                margin-top: 5%;
            }
            
            h1 {
                font-size: 28px;
            }
            
            .subtitle {
                font-size: 16px;
            }
            
            .card {
                padding: 25px;
            }
            
            .top-right {
                position: relative;
                right: auto;
                top: auto;
                margin-bottom: 20px;
                text-align: center;
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
        }
    </style>
</head>
<body>

<div class="top-right">
    <a href="<%= request.getContextPath() %>/modules/userManagementModule/dashboards/studentDashboard.jsp" class="home-link">
        <i class="fas fa-home"></i>
        SmileSpace 
    </a>
</div>

<div class="container">
    <div class="details-icon">
        <i class="fas fa-calendar-alt"></i>
    </div>
    
    <h1>Session Details</h1>
    
    <div class="subtitle">
        Complete information about the counseling session
    </div>

    <div class="card">
        <h2>
            Session Information
            <%
                String status = sessionObj.getStatus();
                String statusClass = "status-pending";
                if (status != null) {
                    if (status.equalsIgnoreCase("scheduled")) {
                        statusClass = "status-scheduled";
                    } else if (status.equalsIgnoreCase("completed")) {
                        statusClass = "status-completed";
                    } else if (status.equalsIgnoreCase("cancelled")) {
                        statusClass = "status-cancelled";
                    }
                }
            %>
            <span class="status-badge <%= statusClass %>">
                <%= status != null ? status : "Pending" %>
            </span>
        </h2>
        
        <div class="detail-row">
            <div class="detail-label">Session ID</div>
            <div class="detail-value"><%= sessionObj.getSessionId() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Student ID</div>
            <div class="detail-value"><%= sessionObj.getStudentId() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Session Type</div>
            <div class="detail-value"><%= sessionObj.getSessionType() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Date & Time</div>
            <div class="detail-value"><%= formattedSessionDate %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Current Mood</div>
            <div class="detail-value">
                <div class="mood-tags">
                    <% 
                        if (sessionObj.getCurrentMood() != null) {
                            String[] moods = sessionObj.getCurrentMood().split(", ");
                            for (String mood : moods) {
                    %>
                        <span class="mood-tag"><%= mood %></span>
                    <% 
                            }
                        } else {
                    %>
                        <span>No mood recorded</span>
                    <% } %>
                </div>
            </div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Follow-up Method</div>
            <div class="detail-value"><%= sessionObj.getFollowUpMethod() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Reason for Session</div>
            <div class="detail-value"><%= sessionObj.getReason() %></div>
        </div>
        
        <% if (sessionObj.getAdditionalNotes() != null && !sessionObj.getAdditionalNotes().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label">Additional Notes</div>
            <div class="detail-value"><%= sessionObj.getAdditionalNotes() %></div>
        </div>
        <% } %>
    </div>

    <div class="card">
        <h2>Student Information</h2>
        
        <div class="detail-row">
            <div class="detail-label">Name</div>
            <div class="detail-value"><%= student.getFullName() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Matric Number</div>
            <div class="detail-value"><%= student.getMatricNumber() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Phone</div>
            <div class="detail-value"><%= student.getPhone() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Email</div>
            <div class="detail-value"><%= student.getEmail() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Program</div>
            <div class="detail-value"><%= student.getProgram() %> - Year <%= student.getYear() %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Recent Mood</div>
            <div class="detail-value">
                <div class="mood-tags">
                    <% 
                        if (student.getRecentMood() != null) {
                            String[] recentMoods = student.getRecentMood().split(", ");
                            for (String mood : recentMoods) {
                    %>
                        <span class="mood-tag"><%= mood %></span>
                    <% 
                            }
                        } else {
                    %>
                        <span>No mood data</span>
                    <% } %>
                </div>
            </div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Risk Level</div>
            <div class="detail-value">
                <%
                    String riskLevel = student.getRiskLevel();
                    if (riskLevel != null) {
                        if (riskLevel.toLowerCase().contains("high")) {
                %>
                    <span class="risk-high"><%= riskLevel %></span>
                <% } else if (riskLevel.toLowerCase().contains("medium")) { %>
                    <span class="risk-medium"><%= riskLevel %></span>
                <% } else if (riskLevel.toLowerCase().contains("low")) { %>
                    <span class="risk-low"><%= riskLevel %></span>
                <% } else { %>
                    <%= riskLevel %>
                <% }
                    } else { %>
                    Unknown
                <% } %>
            </div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Mood Stability</div>
            <div class="detail-value"><%= String.format("%.0f%%", student.getMoodStability()) %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Frequent Tags</div>
            <div class="detail-value"><%= student.getFrequentTags() != null ? student.getFrequentTags() : "No tags" %></div>
        </div>
        
        <div class="detail-row">
            <div class="detail-label">Assessment Category</div>
            <div class="detail-value"><%= student.getAssessmentCategory() != null ? student.getAssessmentCategory() : "No assessment" %></div>
        </div>
    </div>

    <% if (isCompleted && sessionObj.getSummary() != null) { %>
    <div class="card">
        <h2>Session Documentation</h2>
        
        <div class="detail-row">
            <div class="detail-label">Session Summary</div>
            <div class="detail-value"><%= sessionObj.getSummary() %></div>
        </div>
        
        <% if (sessionObj.getProgressNotes() != null && !sessionObj.getProgressNotes().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label">Progress Notes</div>
            <div class="detail-value"><%= sessionObj.getProgressNotes() %></div>
        </div>
        <% } %>
        
        <% if (sessionObj.getFollowUpActions() != null && !sessionObj.getFollowUpActions().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label">Follow-Up Actions</div>
            <div class="detail-value"><%= sessionObj.getFollowUpActions() %></div>
        </div>
        <% } %>
        
        <% if (sessionObj.getNextSessionSuggested() != null && !sessionObj.getNextSessionSuggested().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label">Next Session Suggested</div>
            <div class="detail-value"><%= sessionObj.getNextSessionSuggested() %></div>
        </div>
        <% } %>
        
        <div class="detail-row">
            <div class="detail-label">Documented Date</div>
            <div class="detail-value"><%= formattedDocumentedDate %></div>
        </div>
    </div>
    <% } %>

    <div class="actions">
        <% if (!isCompleted && !isCancelled) { %>
        <a href="counseling?action=documentSession&sessionId=<%= sessionObj.getSessionId() %>" class="btn primary-btn">
            <i class="fas fa-file-medical"></i> Document Session
        </a>
        <% } %>
        <form action="counseling" method="post" style="display: inline;">
            <input type="hidden" name="action" value="deleteSession">
            <input type="hidden" name="sessionId" value="<%= sessionObj.getSessionId() %>">
            <button type="submit" class="btn danger-btn" 
                    onclick="return confirm('Are you sure you want to delete this session?')">
                <i class="fas fa-trash"></i> Delete Session
            </button>
        </form>
        <a href="counseling?action=professionalSessions" class="btn secondary-btn">
            <i class="fas fa-arrow-left"></i> Back to Sessions
        </a>
    </div>
</div>
</body>
</html>