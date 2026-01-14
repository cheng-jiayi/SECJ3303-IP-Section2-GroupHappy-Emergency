<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.CounselingSession" %>
<%@ page import="smilespace.model.MHP" %>
<%@ page import="smilespace.model.User" %>
<%
    List<CounselingSession> sessions = (List<CounselingSession>) request.getAttribute("sessions");
    MHP mhp = (MHP) request.getAttribute("mhp");
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Sessions - SmileSpace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #FFF8E8;
            font-family: 'Inter', sans-serif;
            color: #6B4F36;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }
        .container {
            width: 90%;
            max-width: 1200px;
            text-align: left;
            margin-top: 3%;
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
        h1 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 40px;
            font-weight: 600;
            text-align: left;
            margin-bottom: 0;
            padding-bottom: 0;
            color: #6B4F36;
        }
        .subtitle {
            font-size: 17px;
            margin-bottom: 20px;
            text-align: left;
            font-weight: 400;
            color: #CF8224;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .sessions-table {
            background: #FFF3C8;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1);
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 20px 15px;
            text-align: left;
            border-bottom: 2px solid #E8D4B9;
        }
        th {
            background: #D7923B;
            color: white;
            font-weight: 600;
            font-size: 15px;
        }
        td {
            background: #FFF3C8;
            color: #6B4F36;
            font-size: 14px;
        }
        tr:hover td {
            background: #FFEBB5;
        }
        .status-scheduled { 
            color: #27AE60; 
            font-weight: 600;
            background: #E8F6F3;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            font-size: 13px;
        }
        .status-completed { 
            color: #3498DB; 
            font-weight: 600;
            background: #E8F4F8;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            font-size: 13px;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap; 
        }
        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            font-family: 'Inter', sans-serif;
            white-space: nowrap;
        }
        .view-btn {
            background: #3498DB;
            color: white;
            text-decoration: none;
        }
        .view-btn:hover {
            background: #2980B9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
            text-decoration: none;
            color: white;
        }
        .document-btn {
            background: #27AE60;
            color: white;
            text-decoration: none;
        }
        .document-btn:hover {
            background: #219653;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.3);
            text-decoration: none;
            color: white;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #8B7355;
        }
        .empty-icon {
            font-size: 60px;
            color: #D4A46D;
            margin-bottom: 10px;
            padding-bottom: 0;
        }
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            th, td {
                padding: 12px 8px;
                font-size: 14px;
            }
            .sessions-table {
                overflow-x: auto;
            }
            table {
                min-width: 600px;
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
    <div class="header">
        <div>
            <h1>My Assigned Sessions</h1>
            <div class="subtitle">
                <% if (mhp != null) { %>
                Welcome, Dr. <%= mhp.getFullName() %> | Specialization: <%= mhp.getSpecialization() %>
                <% } else { %>
                Mental Health Professional Dashboard
                <% } %>
            </div>
        </div>
    </div>
    <div class="sessions-table">
        <% if (sessions == null || sessions.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
                <h3>No Assigned Sessions</h3>
                <p>You don't have any counseling sessions assigned to you yet.</p>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Date & Time</th>
                        <th>Session Type</th>
                        <th>Current Mood</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(CounselingSession counselingSession : sessions) { %>
                    <tr>
                        <td><%= counselingSession.getStudentId() %></td>
                        <td><%= counselingSession.getFormattedDateTime() %></td>
                        <td><%= counselingSession.getSessionType() %></td>
                        <td><%= counselingSession.getCurrentMood() %></td>
                        <td><%= counselingSession.getReason() %></td>
                        <td>
                            <span class="status-<%= counselingSession.getStatus().toLowerCase() %>">
                                <%= counselingSession.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="<%= request.getContextPath() %>/VirtualCounselingServlet?action=sessionDetails&sessionId=<%= counselingSession.getSessionId() %>" 
                                   class="action-btn view-btn">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <% if ("Scheduled".equals(counselingSession.getStatus())) { %>
                                <a href="<%= request.getContextPath() %>/VirtualCounselingServlet?action=documentSession&sessionId=<%= counselingSession.getSessionId() %>" 
                                   class="action-btn document-btn">
                                    <i class="fas fa-file-medical"></i> Document
                                </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>
</body>
</html>