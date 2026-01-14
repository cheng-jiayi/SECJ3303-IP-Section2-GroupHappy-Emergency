<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.Referral" %>
<%@ page import="smilespace.model.Student" %>
<%
    Referral referral = (Referral) request.getAttribute("referral");
    Student student = (Student) request.getAttribute("student");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Referral Submitted - SmileSpace</title>
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

        .top-right {
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

        .container {
            width: 90%;
            max-width: 1200px;
            text-align: center;
            margin-top: 3%;
        }

        h1 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 36px;
            font-weight: 600;
            color: #6B4F36;
            margin-bottom: 10px;
        }

        .subtitle {
            font-size: 17px;
            margin-bottom: 30px;
            font-weight: 400;
            color: #CF8224;
        }

        .referral-id {
            background: #FFF3C8;
            padding: 10px 20px;
            border-radius: 25px;
            display: inline-block;
            margin-bottom: 30px;
            font-size: 16px;
            font-weight: 600;
            color: #6B4F36;
            box-shadow: 0px 2px 8px rgba(107, 79, 54, 0.1);
        }

        /* Main content layout */
        .main-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            align-items: start;
            margin-bottom: 30px;
        }

        .card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1);
            text-align: left;
            height: fit-content;
        }

        .card h2 {
            font-family: 'Inter', sans-serif;
            font-size: 22px;
            color: #6B4F36;
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E8D4B9;
        }

        .student-details {
            padding: 0 20px;
            background: #fff3e2;
            border-radius: 12px;
            border-left: 5px solid #a1743d;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 2px solid #e0ba88;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #7e5625;
            font-size: 14px;
            min-width: 180px;
        }

        .detail-value {
            color: #6B4F36;
            font-size: 14px;
            font-weight: 500;
            text-align: left;
            flex: 1;
        }
        
        .risk-high { 
            color: #E74C3C; 
            font-weight: 600;
            background: #FFE8E6;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            font-size: 13px;
        }

        .risk-medium { 
            color: #F39C12; 
            font-weight: 600;
            background: #FFF0D6;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            font-size: 13px;
        }

        .risk-low { 
            color: #27AE60; 
            font-weight: 600;
            background: #E8F6F3;
            padding: 6px 12px;
            border-radius: 20px;
            display: inline-block;
            font-size: 13px;
        }

        .notes-box {
            background: white;
            padding: 12px;
            border-radius: 8px;
            border-left: 4px solid #D7923B;
            margin-top: 8px;
        }

        .custom-reason {
            margin-top: 8px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #D7923B;
            font-style: italic;
        }

        .actions {
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .action-btn {
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            font-family: 'Inter', sans-serif;
            margin: 30px;
        }

        .primary-btn {
            background: #D7923B;
            color: white;
        }

        .primary-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3);
        }

        /* Responsive design */
        @media (max-width: 1024px) {
            .main-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .container {
                width: 95%;
            }
        }

        @media (max-width: 768px) {
            .detail-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            
            .detail-label {
                min-width: auto;
            }
            
            .actions {
                flex-direction: column;
                align-items: center;
            }
            
            .action-btn {
                width: 80%;
                justify-content: center;
            }
            
            h1 {
                font-size: 32px;
            }
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
    <h1>Referral Submitted Successfully!</h1>
    <div class="referral-id">Referral ID: <%= referral.getReferralId() %></div>
    <div class="subtitle">The student has been referred for counseling support.</div>

    <div class="main-content">
        <!-- Student Information Card (Left) -->
        <div class="card">
            <h2>Student Information</h2>
            <div class="student-details">
                <div class="detail-row">
                    <div class="detail-label">Name</div>
                    <div class="detail-value"><%= student.getName() %></div>
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
                    <div class="detail-label">Program / Year</div>
                    <div class="detail-value"><%= student.getProgramYear() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Recent Mood</div>
                    <div class="detail-value"><%= student.getRecentMood() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Risk Level</div>
                    <div class="detail-value">
                        <span class="risk-<%= student.getRiskLevel().toLowerCase() %>">
                            <%= student.getRiskLevel() %>
                        </span>
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Frequent Tags</div>
                    <div class="detail-value"><%= student.getFrequentTags() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Mood Stability</div>
                    <div class="detail-value">
                        <strong><%= String.format("%.0f%%", student.getMoodStability()) %></strong> 
                        (<%= student.getMoodStabilityText() %>)
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Assessment Category</div>
                    <div class="detail-value"><%= student.getAssessmentCategory() %></div>
                </div>
            </div>
        </div>

        <!-- Referral Details Card (Right) -->
        <div class="card">
            <h2><i class="fas fa-file-medical"></i> Referral Details</h2>
            <div class="student-details">
                <div class="detail-row">
                    <div class="detail-label">Reason for Referral</div>
                    <div class="detail-value">
                        <% 
                            String reason = referral.getReason();
                            if (reason != null && reason.startsWith("Other: ")) {
                                String customReason = reason.substring(7);
                        %>
                            <div>
                                <strong>Other</strong>
                                <div class="custom-reason">
                                    <%= customReason %>
                                </div>
                            </div>
                        <%
                            } else {
                        %>
                            <%= reason %>
                        <%
                            }
                        %>
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Urgency / Priority</div>
                    <div class="detail-value"><%= referral.getUrgency() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Notification Method</div>
                    <div class="detail-value"><%= referral.getNotify() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Referral Date</div>
                    <div class="detail-value"><%= referral.getFormattedDate() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Faculty Notes</div>
                    <div class="detail-value">
                        <div class="notes-box">
                            <%= referral.getNotes() != null ? referral.getNotes() : "No additional notes provided." %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/referral" class="action-btn primary-btn">
            <i class="fas fa-users"></i> View More Students
        </a>
    </div>
</div>

</body>
</html>