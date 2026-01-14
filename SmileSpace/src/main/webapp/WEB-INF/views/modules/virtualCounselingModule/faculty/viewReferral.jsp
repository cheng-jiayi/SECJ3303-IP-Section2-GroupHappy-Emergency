<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.Referral" %>
<%@ page import="smilespace.model.Student" %>
<%@ page import="smilespace.model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Referral referral = (Referral) request.getAttribute("referral");
    Student student = (Student) request.getAttribute("student");
    User currentUser = (User) session.getAttribute("user");
    
    if (referral == null || student == null) {
        response.sendRedirect(request.getContextPath() + "/referral");
        return;
    }
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
    String formattedDate = referral.getReferralDate() != null ? 
                           referral.getReferralDate().format(dateFormatter) : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Referral Details - SmileSpace</title>
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
            margin: 80px auto 40px;
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

        h1 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 36px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 10px;
            color: #6B4F36;
        }

        .subtitle {
            font-size: 18px;
            margin-bottom: 40px;
            text-align: center;
            font-weight: 400;
            color: #CF8224;
        }

        .referral-header {
            background: #FFF3C8;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            border: 2px solid #E8D4B9;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .referral-id {
            font-family: 'Preahvihear', sans-serif;
            font-size: 24px;
            font-weight: bold;
            color: #6B4F36;
            background: white;
            padding: 10px 20px;
            border-radius: 25px;
            border: 2px solid #D7923B;
        }

        .referral-date {
            font-size: 16px;
            color: #8B7355;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .card-container {
                grid-template-columns: 1fr;
            }
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(107, 79, 54, 0.1);
            border: 1px solid #E8D4B9;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(107, 79, 54, 0.15);
        }

        .card h2 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 22px;
            font-weight: 600;
            color: #6B4F36;
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 12px;
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

        .info-grid {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .info-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #E8D4B9;
            align-items: flex-start;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #7e5625;
            font-size: 14px;
            width: 200px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-label i {
            color: #D7923B;
            width: 18px;
            text-align: center;
        }

        .info-value {
            color: #6B4F36;
            font-size: 14px;
            font-weight: 500;
            flex: 1;
            line-height: 1.5;
        }

        /* Status Badges */
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .status-pending {
            background: #FFF3CD;
            color: #856404;
            border: 1px solid #FFE8A6;
        }

        .status-accepted {
            background: #D1ECF1;
            color: #0C5460;
            border: 1px solid #A3E4F7;
        }

        .status-completed {
            background: #D4EDDA;
            color: #155724;
            border: 1px solid #9FE6B3;
        }

        .status-rejected {
            background: #F8D7DA;
            color: #721C24;
            border: 1px solid #F5B7B1;
        }

        /* Urgency Badges */
        .urgency-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .urgency-high {
            background: #E74C3C;
            color: white;
        }

        .urgency-medium {
            background: #F39C12;
            color: white;
        }

        .urgency-low {
            background: #27AE60;
            color: white;
        }

        /* Notes Box */
        .notes-box {
            background: #FFF9F0;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #D7923B;
            margin-top: 8px;
            font-size: 14px;
            line-height: 1.5;
            color: #6B4F36;
        }

        /* Counselor Info */
        .counselor-info {
            background: #E8F4FD;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #AED6F1;
            margin-top: 10px;
        }

        .counselor-info h3 {
            font-family: 'Preahvihear', sans-serif;
            font-size: 16px;
            color: #2C3E50;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .counselor-info h3 i {
            color: #3498DB;
        }

        /* Actions */
        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
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
            font-family: 'Inter', sans-serif;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background: #D7923B;
            color: white;
            border: 1px solid #D7923B;
        }

        .btn-primary:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(215, 146, 59, 0.4);
            text-decoration: none;
            color: white;
        }

        .btn-secondary {
            background: #8B7355;
            color: white;
            border: 1px solid #8B7355;
        }

        .btn-secondary:hover {
            background: #6B4F36;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
            box-shadow: 0 6px 15px rgba(107, 79, 54, 0.3);
        }

        /* Student Info */
        .student-contact {
            display: flex;
            gap: 15px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #6B4F36;
        }

        .contact-item a {
            color: #3498DB;
            text-decoration: none;
            transition: color 0.3s;
        }

        .contact-item a:hover {
            color: #2980B9;
            text-decoration: underline;
        }

        .contact-item i {
            color: #D7923B;
            font-size: 14px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #8B7355;
            font-style: italic;
            background: rgba(255, 243, 200, 0.3);
            border-radius: 10px;
            border: 1px dashed #E8D4B9;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .info-row {
                flex-direction: column;
                gap: 6px;
                padding: 10px 0;
            }
            
            .info-label {
                width: 100%;
                font-size: 13px;
            }
            
            .info-value {
                font-size: 13px;
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
                margin-top: 60px;
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
            
            .referral-header {
                flex-direction: column;
                text-align: center;
                padding: 20px;
            }
            
            .referral-id {
                font-size: 20px;
                padding: 8px 16px;
            }
        }

        @media (max-width: 480px) {
            .card {
                padding: 20px;
            }
            
            h1 {
                font-size: 24px;
            }
            
            .subtitle {
                font-size: 15px;
            }
            
            .card h2 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>

<div class="top-right">
    <a href="<%= request.getContextPath() %>/dashboard" class="home-link">
        <i class="fas fa-home"></i>
        SmileSpace 
    </a>
</div>

<div class="container">
    <div style="text-align: center;">
        <h1>Referral Details</h1>
        <div class="subtitle">
            View all information about this referral
        </div>
    </div>

    <!-- Referral Header -->
    <div class="referral-header">
        <div class="referral-id">
            Referral #<%= referral.getReferralId() %>
        </div>
        <div class="referral-date">
            <i class="fas fa-calendar-alt"></i>
            Submitted on: <%= formattedDate %>
        </div>
    </div>

    <!-- Main Content Grid -->
    <div class="card-container">
        <!-- Student Information Card -->
        <div class="card">
            <h2><i class="fas fa-user-graduate"></i> Student Information</h2>
            <div class="info-grid">
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-user"></i> Name</div>
                    <div class="info-value"><%= student.getFullName() %></div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-id-card"></i> Student ID</div>
                    <div class="info-value"><%= student.getStudentId() %></div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-hashtag"></i> Matric Number</div>
                    <div class="info-value"><%= student.getMatricNumber() %></div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-graduation-cap"></i> Program / Year</div>
                    <div class="info-value"><%= student.getProgramYear() %></div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-chart-line"></i> Risk Level</div>
                    <div class="info-value">
                        <span class="urgency-<%= student.getRiskLevel() != null ? student.getRiskLevel().toLowerCase() : "low" %> urgency-badge">
                            <%= student.getRiskLevel() != null ? student.getRiskLevel() : "LOW" %>
                        </span>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-smile"></i> Recent Mood</div>
                    <div class="info-value"><%= student.getRecentMood() != null ? student.getRecentMood() : "Not available" %></div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-tags"></i> Frequent Tags</div>
                    <div class="info-value"><%= student.getFrequentTags() != null ? student.getFrequentTags() : "None" %></div>
                </div>
                
                <!-- Student Contact Information -->
                <div class="student-contact">
                    <% if (student.getEmail() != null && !student.getEmail().isEmpty()) { %>
                    <div class="contact-item">
                        <i class="fas fa-envelope"></i>
                        <a href="mailto:<%= student.getEmail() %>"><%= student.getEmail() %></a>
                    </div>
                    <% } %>
                    
                    <% if (student.getPhone() != null && !student.getPhone().isEmpty()) { %>
                    <div class="contact-item">
                        <i class="fas fa-phone"></i>
                        <a href="tel:<%= student.getPhone() %>"><%= student.getPhone() %></a>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Referral Details Card -->
        <div class="card">
            <h2><i class="fas fa-file-medical"></i> Referral Details</h2>
            <div class="info-grid">
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-user-md"></i> Referring Faculty</div>
                    <div class="info-value"><%= referral.getFacultyName() %></div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-exclamation-circle"></i> Urgency Level</div>
                    <div class="info-value">
                        <span class="urgency-<%= referral.getUrgency() != null ? referral.getUrgency().toLowerCase() : "medium" %> urgency-badge">
                            <i class="fas fa-<%= 
                                "high".equalsIgnoreCase(referral.getUrgency()) ? "exclamation-triangle" : 
                                "medium".equalsIgnoreCase(referral.getUrgency()) ? "exclamation-circle" : "info-circle" 
                            %>"></i>
                            <%= referral.getUrgency() != null ? referral.getUrgency() : "MEDIUM" %>
                        </span>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-question-circle"></i> Reason for Referral</div>
                    <div class="info-value"><%= referral.getReason() %></div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-flag"></i> Referral Status</div>
                    <div class="info-value">
                        <span class="status-<%= referral.getStatus() != null ? referral.getStatus().toLowerCase() : "pending" %> status-badge">
                            <i class="fas fa-<%= 
                                "pending".equalsIgnoreCase(referral.getStatus()) ? "clock" : 
                                "accepted".equalsIgnoreCase(referral.getStatus()) ? "check-circle" :
                                "completed".equalsIgnoreCase(referral.getStatus()) ? "clipboard-check" : "times-circle"
                            %>"></i>
                            <%= referral.getStatus() != null ? referral.getStatus() : "PENDING" %>
                        </span>
                    </div>
                </div>
                
                <% if (referral.getCounselorName() != null && !referral.getCounselorName().isEmpty()) { %>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-user-md"></i> Assigned Counselor</div>
                    <div class="info-value">
                        <div class="counselor-info">
                            <h3><i class="fas fa-user-md"></i> <%= referral.getCounselorName() %></h3>
                            <div>This referral has been accepted by a counselor</div>
                        </div>
                    </div>
                </div>
                <% } %>
                
                <% if (referral.getNotes() != null && !referral.getNotes().isEmpty()) { %>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-sticky-note"></i> Faculty Notes</div>
                    <div class="info-value">
                        <div class="notes-box">
                            <%= referral.getNotes() %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Timeline Card (Optional - shows referral progress) -->
    <div class="card">
        <h2><i class="fas fa-history"></i> Referral Timeline</h2>
        <div class="info-grid">
            <div class="info-row">
                <div class="info-label"><i class="fas fa-paper-plane"></i> Referral Submitted</div>
                <div class="info-value">
                    <i class="fas fa-calendar-check" style="color: #27AE60; margin-right: 8px;"></i>
                    <%= formattedDate %>
                </div>
            </div>
            
            <% if ("ACCEPTED".equalsIgnoreCase(referral.getStatus()) || "COMPLETED".equalsIgnoreCase(referral.getStatus())) { %>
            <div class="info-row">
                <div class="info-label"><i class="fas fa-user-check"></i> Accepted by Counselor</div>
                <div class="info-value">
                    <i class="fas fa-calendar-check" style="color: #3498DB; margin-right: 8px;"></i>
                    <% if (referral.getCounselorName() != null) { %>
                        By: <%= referral.getCounselorName() %>
                    <% } else { %>
                        Accepted - Awaiting counselor assignment
                    <% } %>
                </div>
            </div>
            <% } %>
            
            <% if ("COMPLETED".equalsIgnoreCase(referral.getStatus())) { %>
            <div class="info-row">
                <div class="info-label"><i class="fas fa-check-double"></i> Session Completed</div>
                <div class="info-value">
                    <i class="fas fa-calendar-check" style="color: #2ECC71; margin-right: 8px;"></i>
                    Counseling session has been completed
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="actions">
        <a href="<%= request.getContextPath() %>/referral" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Students List
        </a>
                
        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">
            <i class="fas fa-home"></i> Back to Dashboard
        </a>
    </div>
</div>

<script>
    // Add some interactive features
    document.addEventListener('DOMContentLoaded', function() {
        // Animate cards on load
        const cards = document.querySelectorAll('.card');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
        
        // Add copy referral ID functionality
        const referralIdElement = document.querySelector('.referral-id');
        referralIdElement.style.cursor = 'pointer';
        referralIdElement.title = 'Click to copy Referral ID';
        
        referralIdElement.addEventListener('click', function() {
            const referralId = this.textContent.replace('Referral #', '').trim();
            navigator.clipboard.writeText(referralId).then(() => {
                const originalText = this.textContent;
                this.textContent = '✓ Copied!';
                this.style.background = '#27AE60';
                this.style.color = 'white';
                
                setTimeout(() => {
                    this.textContent = originalText;
                    this.style.background = '';
                    this.style.color = '';
                }, 2000);
            });
        });
    });
</script>
</body>
</html>