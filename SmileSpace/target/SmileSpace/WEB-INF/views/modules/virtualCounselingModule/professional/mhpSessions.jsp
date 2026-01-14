<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="smilespace.model.CounselingSession" %>
<%@ page import="smilespace.model.Professional" %>
<%@ page import="smilespace.model.Referral" %>
<%@ page import="smilespace.model.User" %>
<%
    List<CounselingSession> mySessions = (List<CounselingSession>) request.getAttribute("mySessions");
    List<CounselingSession> unassignedSessions = (List<CounselingSession>) request.getAttribute("unassignedSessions");
    List<Referral> pendingReferrals = (List<Referral>) request.getAttribute("pendingReferrals");
    Professional professional = (Professional) request.getAttribute("professional");
    User user = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Counseling Dashboard - SmileSpace</title>
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
        }
        .container {
            width: 95%;
            max-width: 1600px;
            margin: 3% auto;
            padding: 20px;
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
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #6B4F36;
        }
        h2 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 28px;
            font-weight: 600;
            margin: 0;
            color: #6B4F36;
            border-bottom: 3px solid #D7923B;
            padding-bottom: 8px;
        }
        .subtitle {
            font-size: 17px;
            margin-bottom: 25px;
            font-weight: 400;
            color: #CF8224;
        }
        .dashboard-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            border: 1px solid #E8D4B9;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .session-count {
            background: #D7923B;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
        }
        .sessions-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .sessions-table th {
            background: #8B7355;
            color: white;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            font-size: 14px;
        }
        .sessions-table td {
            padding: 15px;
            border-bottom: 1px solid #E8D4B9;
            font-size: 14px;
        }
        .sessions-table tr:hover {
            background-color: #FFF9F0;
        }
        .checkbox-cell {
            width: 50px;
            text-align: center;
        }
        .student-info {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }
        .student-name {
            font-weight: 600;
            color: #6B4F36;
        }
        .student-details {
            font-size: 12px;
            color: #8B7355;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .status-pending {
            background: #FFF3CD;
            color: #856404;
        }
        .status-scheduled {
            background: #D1ECF1;
            color: #0C5460;
        }
        .status-completed {
            background: #D4EDDA;
            color: #155724;
        }
        .status-cancelled {
            background: #F8D7DA;
            color: #721C24;
        }
        .status-pending-assignment {
            background: #FFF3CD;
            color: #856404;
        }
        .urgency-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .urgency-high {
            background: #F8D7DA;
            color: #721C24;
            border: 1px solid #F5C6CB;
        }
        .urgency-medium {
            background: #FFF3CD;
            color: #856404;
            border: 1px solid #FFEEBA;
        }
        .urgency-low {
            background: #D1ECF1;
            color: #0C5460;
            border: 1px solid #BEE5EB;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
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
            gap: 8px;
            transition: all 0.3s;
        }
        .view-btn {
            background: #3498DB;
            color: white;
        }
        .view-btn:hover {
            background: #2980B9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }
        .document-btn {
            background: #27AE60;
            color: white;
        }
        .document-btn:hover {
            background: #219653;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.3);
        }
        .accept-btn {
            background: #2ECC71;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        .accept-btn:hover {
            background: #27AE60;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
        }
        .bulk-actions {
            background: #FFF3C8;
            padding: 15px;
            border-radius: 10px;
            margin-top: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .select-all {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #8B7355;
        }
        .empty-icon {
            font-size: 50px;
            color: #D4A46D;
            margin-bottom: 15px;
        }
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        .btn {
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            font-family: 'Preahvihear', sans-serif;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #D7923B;
            color: white;
        }
        .btn-primary:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3);
        }
        .btn-secondary {
            background: #8B7355;
            color: white;
        }
        .btn-secondary:hover {
            background: #6B4F36;
            transform: translateY(-2px);
        }
        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            background: #D1ECF1;
            color: #0C5460;
            border-left: 5px solid #3498DB;
        }
        .referral-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .referral-submitted {
            font-size: 11px;
            color: #8B7355;
            font-style: italic;
        }
        .referral-reason {
            font-size: 13px;
            color: #6B4F36;
            margin-top: 3px;
        }
        .referral-accept-btn {
            background: #9B59B6;
            color: white;
        }
        .referral-accept-btn:hover {
            background: #8E44AD;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(155, 89, 182, 0.3);
        }
        .tab-container {
            display: flex;
            border-bottom: 2px solid #E8D4B9;
            margin-bottom: 20px;
            padding: 0 5px;
        }
        .tab {
            padding: 12px 25px;
            cursor: pointer;
            font-weight: 600;
            color: #8B7355;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
            position: relative;
            bottom: -2px;
        }
        .tab:hover {
            color: #D7923B;
        }
        .tab.active {
            color: #D7923B;
            border-bottom: 3px solid #D7923B;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
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
    <div>
        <h1>Counseling Sessions Dashboard</h1>
        <div class="subtitle">
            <% if (professional != null) { %>
            Welcome, <%= professional.getFullName() %> 
            <% if (professional.getSpecialization() != null && !professional.getSpecialization().isEmpty()) { %>
            | Specialization: <%= professional.getSpecialization() %>
            <% } %>
            <% } else { %>
            Mental Health Professional Dashboard
            <% } %>
        </div>
    </div>

    <!-- Tabs for better organization -->
    <div class="tab-container">
        <button class="tab active" onclick="showTab('sessions')">
            <i class="fas fa-calendar-check"></i> My Sessions (<%= mySessions != null ? mySessions.size() : 0 %>)
        </button>
        <button class="tab" onclick="showTab('available')">
            <i class="fas fa-calendar-plus"></i> Available Sessions (<%= unassignedSessions != null ? unassignedSessions.size() : 0 %>)
        </button>
        <button class="tab" onclick="showTab('referrals')">
            <i class="fas fa-user-md"></i> Faculty Referrals (<%= pendingReferrals != null ? pendingReferrals.size() : 0 %>)
        </button>
    </div>

    <!-- TAB 1: MY ASSIGNED SESSIONS -->
    <div id="sessions-tab" class="tab-content active">
        <div class="dashboard-section">
            <div class="section-header">
                <h2>My Assigned Sessions</h2>
                <span class="session-count"><%= mySessions != null ? mySessions.size() : 0 %> sessions</span>
            </div>
            
            <% if (mySessions == null || mySessions.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fas fa-calendar-times"></i></div>
                    <h3>No Assigned Sessions</h3>
                    <p>You haven't accepted any counseling sessions yet.</p>
                </div>
            <% } else { %>
                <table class="sessions-table">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Date & Time</th>
                            <th>Session Type</th>
                            <th>Current Mood</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(CounselingSession cs : mySessions) { %>
                        <tr>
                            <td>
                                <div class="student-info">
                                    <span class="student-name">
                                        <% if (cs.getStudentName() != null) { %>
                                            <%= cs.getStudentName() %>
                                        <% } else { %>
                                            Student #<%= cs.getStudentId() %>
                                        <% } %>
                                    </span>
                                    <span class="student-details">
                                        <%= cs.getStudentEmail() != null ? cs.getStudentEmail() : "" %>
                                    </span>
                                </div>
                            </td>
                            <td><%= cs.getFormattedDateTime() %></td>
                            <td><%= cs.getSessionType() != null ? cs.getSessionType() : "" %></td>
                            <td><%= cs.getCurrentMood() != null ? cs.getCurrentMood() : "" %></td>
                            <td><%= cs.getReason() != null ? cs.getReason() : "" %></td>
                            <td>
                                <%
                                    String status = cs.getStatus();
                                    String statusClass = "status-pending";
                                    if (status != null) {
                                        if (status.equalsIgnoreCase("pending assignment")) {
                                            statusClass = "status-pending-assignment";
                                        } else if (status.equalsIgnoreCase("scheduled")) {
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
                            </td>
                            <td>
                            <div class="action-buttons">
                                <a href="counseling?action=sessionDetails&sessionId=<%= cs.getSessionId() %>" 
                                    class="action-btn view-btn">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <% if (cs.isScheduled()) { %>
                                <a href="<%= contextPath %>/counseling?action=documentSession&sessionId=<%= cs.getSessionId() %>" 
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

    <!-- TAB 2: AVAILABLE SESSIONS TO ACCEPT -->
    <div id="available-tab" class="tab-content">
        <div class="dashboard-section">
            <div class="section-header">
                <h2>Available Sessions to Accept</h2>
                <span class="session-count"><%= unassignedSessions != null ? unassignedSessions.size() : 0 %> available</span>
            </div>
            
            <% if (unassignedSessions == null || unassignedSessions.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fas fa-check-circle"></i></div>
                    <h3>No Available Sessions</h3>
                    <p>All sessions have been assigned to counselors.</p>
                </div>
            <% } else { %>
                <form id="acceptSessionsForm" method="post" action="<%= contextPath %>/counseling">
                    <input type="hidden" name="action" value="acceptSessions">
                    
                    <table class="sessions-table">
                        <thead>
                            <tr>
                                <th class="checkbox-cell">
                                    <input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)">
                                </th>
                                <th>Student</th>
                                <th>Date & Time</th>
                                <th>Session Type</th>
                                <th>Current Mood</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(CounselingSession sess : unassignedSessions) { %>
                            <tr>
                                <td class="checkbox-cell">
                                    <input type="checkbox" 
                                        name="sessionIds" 
                                        value="<%= sess.getSessionId() %>"
                                        class="session-checkbox">
                                </td>
                                <td>
                                    <div class="student-info">
                                        <span class="student-name">
                                            <% if (sess.getStudentName() != null) { %>
                                                <%= sess.getStudentName() %>
                                            <% } else { %>
                                                Student #<%= sess.getStudentId() %>
                                            <% } %>
                                        </span>
                                        <span class="student-details">
                                            <%= sess.getStudentEmail() != null ? sess.getStudentEmail() : "" %>
                                        </span>
                                    </div>
                                </td>
                                <td><%= sess.getFormattedDateTime() %></td>
                                <td><%= sess.getSessionType() != null ? sess.getSessionType() : "" %></td>
                                <td><%= sess.getCurrentMood() != null ? sess.getCurrentMood() : "" %></td>
                                <td><%= sess.getReason() != null ? sess.getReason() : "" %></td>
                                <td>
                                    <%
                                        String status2 = sess.getStatus();
                                        String statusClass2 = "status-pending";
                                        if (status2 != null) {
                                            if (status2.equalsIgnoreCase("pending assignment")) {
                                                statusClass2 = "status-pending-assignment";
                                            }
                                        }
                                    %>
                                    <span class="status-badge <%= statusClass2 %>">
                                        <%= status2 != null ? status2 : "Pending Assignment" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <button type="button" 
                                                class="accept-btn"
                                                onclick="acceptSingleSession('<%= sess.getSessionId() %>')">
                                            <i class="fas fa-check-circle"></i> Accept
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    
                    <div class="bulk-actions">
                        <div class="select-all">
                            <input type="checkbox" id="selectAllBottom" onclick="toggleSelectAll(this)">
                            <label for="selectAllBottom">Select All Available Sessions</label>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-user-check"></i> Accept Selected Sessions
                        </button>
                    </div>
                </form>
            <% } %>
        </div>
    </div>

    <!-- TAB 3: FACULTY REFERRALS -->
    <div id="referrals-tab" class="tab-content">
        <div class="dashboard-section">
            <div class="section-header">
                <h2>Faculty Referrals</h2>
                <span class="session-count"><%= pendingReferrals != null ? pendingReferrals.size() : 0 %> pending</span>
            </div>
            
            <% if (pendingReferrals == null || pendingReferrals.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fas fa-inbox"></i></div>
                    <h3>No Pending Referrals</h3>
                    <p>There are no faculty referrals waiting for review.</p>
                </div>
            <% } else { %>
                <table class="sessions-table">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Submitted By</th>
                            <th>Date Referred</th>
                            <th>Reason</th>
                            <th>Urgency</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Referral referral : pendingReferrals) { %>
                        <tr>
                            <td>
                                <div class="student-info">
                                    <span class="student-name">
                                        <% if (referral.getStudentName() != null) { %>
                                            <%= referral.getStudentName() %>
                                        <% } else { %>
                                            Student #<%= referral.getStudentId() %>
                                        <% } %>
                                    </span>
                                    <span class="student-details">
                                        <% if (referral.getStudentMatric() != null) { %>
                                            <%= referral.getStudentMatric() %>
                                        <% } %>
                                        <% if (referral.getStudentFaculty() != null) { %>
                                            | <%= referral.getStudentFaculty() %>
                                            <% if (referral.getStudentYear() > 0) { %>
                                                Year <%= referral.getStudentYear() %>
                                            <% } %>
                                        <% } %>
                                    </span>
                                </div>
                            </td>
                            <td>
                                <div class="referral-info">
                                    <span class="student-name">
                                        <% if (referral.getFacultyName() != null) { %>
                                            <%= referral.getFacultyName() %>
                                        <% } else { %>
                                            Faculty #<%= referral.getFacultyId() %>
                                        <% } %>
                                    </span>
                                    <span class="referral-submitted">
                                        Submitted on <%= referral.getFormattedDate() %>
                                    </span>
                                </div>
                            </td>
                            <td><%= referral.getFormattedDate() %></td>
                            <td>
                                <div class="referral-info">
                                    <span class="student-name">
                                        <%= referral.getReason() != null ? referral.getReason() : "No reason provided" %>
                                    </span>
                                    <% if (referral.getNotes() != null && !referral.getNotes().isEmpty()) { %>
                                    <span class="referral-reason">
                                        <i class="fas fa-sticky-note"></i> <%= referral.getNotes().length() > 50 ? 
                                            referral.getNotes().substring(0, 50) + "..." : referral.getNotes() %>
                                    </span>
                                    <% } %>
                                </div>
                            </td>
                            <td>
                                <%
                                    String urgency = referral.getUrgency();
                                    String urgencyClass = "urgency-low";
                                    if (urgency != null) {
                                        if (urgency.equalsIgnoreCase("HIGH")) {
                                            urgencyClass = "urgency-high";
                                        } else if (urgency.equalsIgnoreCase("MEDIUM")) {
                                            urgencyClass = "urgency-medium";
                                        }
                                    }
                                %>
                                <span class="urgency-badge <%= urgencyClass %>">
                                    <%= urgency != null ? urgency : "LOW" %>
                                </span>
                            </td>
                            <td>
                                <span class="status-badge status-pending">
                                    <%= referral.getStatus() != null ? referral.getStatus() : "PENDING" %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <form method="post" action="<%= contextPath %>/referral/accept" style="display:inline;">
                                        <input type="hidden" name="referralId" value="<%= referral.getReferralId() %>">
                                        <button type="submit" class="action-btn referral-accept-btn">
                                            <i class="fas fa-user-check"></i> Accept Referral
                                        </button>
                                    </form>
                                    <button type="button" class="action-btn view-btn" onclick="viewReferralDetails('<%= referral.getReferralId() %>')">
                                        <i class="fas fa-eye"></i> Details
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <div class="alert" style="margin-top: 20px;">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Note:</strong> Accepting a referral will automatically create a counseling session for the student 
                    and assign you as the counselor. The session will be scheduled for 3 days from now.
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
// Tab functionality
function showTab(tabName) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Show selected tab
    document.getElementById(tabName + '-tab').classList.add('active');
    
    // Update active tab button
    document.querySelectorAll('.tab').forEach(tabBtn => {
        tabBtn.classList.remove('active');
    });
    event.currentTarget.classList.add('active');
}

function acceptSingleSession(sessionId) {
    console.log("Accepting session: " + sessionId);
    if (confirm('Are you sure you want to accept this session?')) {
        var form = document.createElement('form');
        form.method = 'post';
        form.action = '<%= contextPath %>/counseling';
        
        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'acceptSingleSession';
        form.appendChild(actionInput);
        
        var sessionInput = document.createElement('input');
        sessionInput.type = 'hidden';
        sessionInput.name = 'sessionId';
        sessionInput.value = sessionId;
        form.appendChild(sessionInput);
        
        document.body.appendChild(form);
        console.log('Submitting form to accept session: ' + sessionId);
        form.submit();
    }
}

function viewReferralDetails(referralId) {
    // Open referral details in a new tab or modal
    window.open('<%= contextPath %>/referral/view?referralId=' + referralId, '_blank');
}

function toggleSelectAll(source) {
    var checkboxes = document.querySelectorAll('.session-checkbox');
    checkboxes.forEach(function(checkbox) {
        checkbox.checked = source.checked;
    });
    // Sync both select all checkboxes
    document.getElementById('selectAll').checked = source.checked;
    document.getElementById('selectAllBottom').checked = source.checked;
}

// Debug logging
console.log("=== DEBUG: Professional Dashboard Loaded ===");
console.log("Pending Referrals Count: <%= pendingReferrals != null ? pendingReferrals.size() : 0 %>");

// Check if buttons are actually clickable
document.addEventListener('DOMContentLoaded', function() {
    var buttons = document.querySelectorAll('.view-btn');
    console.log("Found " + buttons.length + " View buttons total");
});
</script>
</body>
</html>