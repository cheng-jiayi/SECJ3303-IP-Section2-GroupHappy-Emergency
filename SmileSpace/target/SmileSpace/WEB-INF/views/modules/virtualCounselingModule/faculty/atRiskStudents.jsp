<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.Student" %>
<%
    List<Student> students = (List<Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>At-Risk Students</title>
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
            width: 80%;
            text-align: left;
            margin-top: 5%;
        }
        
        .top-right {
            font-family: 'Preahvihear', sans-serif;
            position: absolute;
            right: 40px;
            top: 20px;
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
            font-size: 36px;
            font-weight: 600;
            text-align: left;
            margin-bottom: 1px;
            padding-bottom: 0;
            color: #6B4F36;
        }

        .subtitle {
            font-size: 17px;
            margin-bottom: 35px;
            text-align: left;
            font-weight: 400;
            color: #CF8224;
        }

        .students-table {
            background: #FFF3C8;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1);
            margin-top: 20px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #E8D4B9;
            min-width: 90px;
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

        .risk-high { 
            color: #E74C3C; 
            font-weight: 600;
            background: #f3cdca;
            padding: 8px 17px;
            border-radius: 20px;
            display: inline-block;
        }

        .risk-medium { 
            color: #F39C12; 
            font-weight: 600;
            background: #fde8c3;
            padding: 8px 17px;
            border-radius: 20px;
            display: inline-block;
        }

        .risk-low { 
            color: #27AE60; 
            font-weight: 600;
            background: #caf7ed;
            padding: 8px 17px;
            border-radius: 20px;
            display: inline-block;
        }
        
        .mood-stability-container {
            line-height: 1.3;
        }
        
        .mood-percentage {
            font-size: 15px;
            font-weight: 600;
            color: #6B4F36;
        }
        
        .mood-text {
            font-size: 14px;
            color: #8B7355;
            margin-top: 2px;
        }
        
        .action-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-grid;
            grid-template-columns: auto auto; 
            align-items: center;
            gap: 8px; 
            text-align: center;
            transition: all 0.3s;
            font-family: 'Inter', sans-serif;
            justify-content: center; 
            white-space: normal;
        }

        .refer-btn {
            background: #D7923B;
            color: white;
            font-size: 15px;
        }

        .refer-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #8B7355;
        }

        .empty-icon {
            font-size: 40px;
            color: #D4A46D;
            margin-bottom: 20px;
        }

        .stats-bar {
            background: #FFF3C8;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            gap: 30px;
            justify-content: center;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 680;
            color: #D7923B;
        }

        .stat-label {
            font-size: 14px;
            color: #8B7355;
            margin-top: 5px;
        }

        .view-btn {
            background: #3498DB;
            color: white;
            font-size: 15px;
        }

        .view-btn:hover {
            background: #2980B9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }

        /* Different colors for different referral statuses */
        .referral-pending {
            background: #FFF3CD;
            color: #856404;
            border: 1px solid #FFE8A6;
        }

        .referral-accepted {
            background: #D1ECF1;
            color: #0C5460;
            border: 1px solid #A3E4F7;
        }

        .referral-completed {
            background: #D4EDDA;
            color: #155724;
            border: 1px solid #9FE6B3;
        }
    </style>
</head>
<body>

<div class="top-right">
    <a href="${pageContext.request.contextPath}/dashboard" class="home-link">
        <i class="fas fa-home"></i>
        SmileSpace 
    </a>
</div>

<div class="container">
    <h1>At-Risk Students</h1>
    <div class="subtitle">Students who may benefit from additional support and counseling.</div>

    <% if (students != null && !students.isEmpty()) { %>
        <!-- Statistics Bar -->
        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-number"><%= students.size() %></div>
                <div class="stat-label">Total Students</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">
                    <% 
                        long highRiskCount = students.stream().filter(s -> "HIGH".equals(s.getRiskLevel())).count();
                    %>
                    <%= highRiskCount %>
                </div>
                <div class="stat-label">High Risk</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">
                    <% 
                        long mediumRiskCount = students.stream().filter(s -> "MEDIUM".equals(s.getRiskLevel())).count();
                    %>
                    <%= mediumRiskCount %>
                </div>
                <div class="stat-label">Medium Risk</div>
            </div>
        </div>

        <div class="students-table">
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Matric Number</th>
                        <th>Recent Mood</th>
                        <th>Risk Level</th>
                        <th>Frequent Tags</th>
                        <th>Mood Stability</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Student student : students) { %>
                    <tr>
                        <td><strong><%= student.getFullName() %></strong></td>
                        <td><%= student.getMatricNumber() %></td>
                        <td><%= student.getRecentMood() != null ? student.getRecentMood() : "Not available" %></td>
                        <td>
                            <span class="risk-<%= student.getRiskLevel() != null ? student.getRiskLevel().toLowerCase() : "low" %>">
                                <%= student.getRiskLevel() != null ? student.getRiskLevel() : "LOW" %>
                            </span>
                        </td>
                        <td><%= student.getFrequentTags() != null ? student.getFrequentTags() : "None" %></td>
                        <td>
                            <div class="mood-percentage"><%= String.format("%.0f%%", student.getMoodStability()) %></div>
                            <div class="mood-text"><%= student.getMoodStabilityText() %></div>
                        </td>
                        <td>
                            <% if (student.hasReferral()) { %>
                                <!-- View Button for existing referrals -->
                                <a href="${pageContext.request.contextPath}/referral/view?referralId=<%= student.getReferralId() != null ? student.getReferralId() : "" %>" 
                                    class="action-btn view-btn">
                                    <i class="fas fa-eye"></i> View
                                </a>
                            <% } else { %>
                                <!-- Refer Button for students without referrals -->
                                <a href="${pageContext.request.contextPath}/referral/referralForm?studentId=<%= student.getStudentId() %>" 
                                class="action-btn refer-btn">
                                <i class="fas fa-hand-holding-heart"></i> Refer
                                </a>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div class="empty-state">
            <div class="empty-icon">
                <i class="fas fa-users-slash"></i>
            </div>
            <h3 style="color: #6B4F36;">No At-Risk Students Found</h3>
            <p style="font-size: 16px; color: #8B7355;">All students are currently doing well! 🎉</p>
            <p style="font-size: 14px; color: #A88C6D; margin-top: 10px;">
                Students will appear here if they show signs of needing additional support.
            </p>
        </div>
    <% } %>
</div>

</body>
</html>