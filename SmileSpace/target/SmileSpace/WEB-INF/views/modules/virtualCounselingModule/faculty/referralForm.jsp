<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.Student" %>
<%
    Student student = (Student) request.getAttribute("student");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Refer Student</title>
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
            text-align: left;
            margin-top: 3%;
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
            margin-bottom: 10px;
            padding-bottom: 0;
            color: #6B4F36;
        }

        .subtitle {
            font-size: 17px;
            text-align: left;
            font-weight: 400;
            color: #CF8224;
        }

        /* Main content layout */
        .main-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            align-items: start;
        }

        .card {
            background: #fff6da;
            border-radius: 15px;
            padding: 25px 30px;
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1);
            height: fit-content;
        }

        .card h2 {
            color: #6B4F36;
            margin-bottom: 25px;
            font-size: 22px;
            font-weight: 650;
            border-bottom: 3px solid #ac7129;
            padding-bottom: 10px;
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

        .form-group {
            margin-bottom: 20px;
            width: 100%;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #6B4F36;
            font-size: 14px;
        }
        
        label.required::after {
            content: " *";
            color: #E74C3C;
        }

        select, textarea, input {
            width: 100%;
            padding: 10px;
            border: 2px solid #E8D4B9;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            background: white;
            color: #6B4F36;
            transition: all 0.3s;
            box-sizing: border-box;
            display: block;
        }

        select:focus, textarea:focus, input:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.2);
        }

        textarea {
            height: 100px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 25px;
        }

        .submit-btn {
            background: #D7923B;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s;
        }

        .submit-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(215, 146, 59, 0.4);
        }

        .cancel-btn {
            background: #8B7355;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .cancel-btn:hover {
            background: #6B4F36;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .back-btn {
            background: #8B7355;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 20px;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
        }

        .back-btn:hover {
            background: #6B4F36;
            transform: translateY(-2px);
            text-decoration: none;
            color: white;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        /* Styles for the conditional other reason field */
        .other-reason-container {
            margin-top: 10px;
            display: none;
            animation: fadeIn 0.3s ease-in;
        }

        .other-reason-container.show {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
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
            .header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .detail-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            
            .detail-label {
                min-width: auto;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .cancel-btn, .submit-btn {
                width: 100%;
                justify-content: center;
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
    <div class="header">
        <div>
            <h1>Student's Info</h1>
            <div class="subtitle">Provide support and care for students in need.</div>
        </div>
        <!-- FIXED LINK: Use correct back link -->
        <a href="${pageContext.request.contextPath}/referral" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Students List
        </a>
    </div>

    <div class="main-content">
        <!-- Student Information Card (Left) -->
        <div class="card">
            <h2>Student Information</h2>
            <div class="student-details">
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
                    <div class="detail-value"><%= student.getPhone() != null ? student.getPhone() : "Not available" %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Email</div>
                    <div class="detail-value"><%= student.getEmail() != null ? student.getEmail() : "Not available" %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Program / Year</div>
                    <div class="detail-value"><%= student.getProgramYear() %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Recent Mood</div>
                    <div class="detail-value"><%= student.getRecentMood() != null ? student.getRecentMood() : "Not available" %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Risk Level</div>
                    <div class="detail-value">
                        <span class="risk-<%= student.getRiskLevel() != null ? student.getRiskLevel().toLowerCase() : "low" %>">
                            <%= student.getRiskLevel() != null ? student.getRiskLevel() : "LOW" %>
                        </span>
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Frequent Tags</div>
                    <div class="detail-value"><%= student.getFrequentTags() != null ? student.getFrequentTags() : "None" %></div>
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
                    <div class="detail-value"><%= student.getAssessmentCategory() != null ? student.getAssessmentCategory() : "Not assessed" %></div>
                </div>
            </div>
        </div>

        <!-- Referral Details Card (Right) -->
        <div class="card">
            <h2>Referral Details</h2>
            <!-- FIXED FORM ACTION: Use correct controller endpoint -->
            <form action="${pageContext.request.contextPath}/referral/submit" method="post" id="referralForm">
                <input type="hidden" name="studentId" value="<%= student.getStudentId() %>">
                
                <div class="form-group">
                    <label for="reason">Reason for Referral *</label>
                    <select id="reason" name="reason" required>
                        <option value="">Select a reason</option>
                        <option value="Academic Stress">Academic Stress</option>
                        <option value="Anxiety Issues">Anxiety Issues</option>
                        <option value="Depression Signs">Depression Signs</option>
                        <option value="Relationship Issues">Relationship Issues</option>
                        <option value="Family Problems">Family Problems</option>
                        <option value="Financial Stress">Financial Stress</option>
                        <option value="Career Concerns">Career Concerns</option>
                        <option value="Other">Other</option>
                    </select>
                    
                    <!-- Conditional input for "Other" reason -->
                    <div id="otherReasonContainer" class="other-reason-container">
                        <label for="otherReason" style="margin-top: 10px;">Please specify the reason *</label>
                        <input type="text" id="otherReason" name="otherReason" placeholder="Enter the specific reason for referral...">
                    </div>
                </div>

                <div class="form-group">
                    <label for="urgency">Urgency / Priority *</label>
                    <select id="urgency" name="urgency" required>
                        <option value="">Select urgency level</option>
                        <option value="High">High - Immediate attention needed</option>
                        <option value="Medium">Medium - Schedule within 1 week</option>
                        <option value="Low">Low - Routine follow-up</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="notify">Notify *</label>
                    <select id="notify" name="notify" required>
                        <option value="">Select notification method</option>
                        <option value="Email">Email</option>
                        <option value="SMS">SMS</option>
                        <option value="WhatsApp">WhatsApp</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="notes">Faculty Notes / Remarks</label>
                    <textarea id="notes" name="notes" placeholder="Share your observations, concerns, or any additional context that might help the counseling team..."></textarea>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/referral" class="cancel-btn">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-paper-plane"></i> Submit Referral
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Handle the conditional "Other" reason field
    document.getElementById('reason').addEventListener('change', function() {
        const otherReasonContainer = document.getElementById('otherReasonContainer');
        const otherReasonInput = document.getElementById('otherReason');
        
        if (this.value === 'Other') {
            otherReasonContainer.classList.add('show');
            otherReasonInput.required = true;
        } else {
            otherReasonContainer.classList.remove('show');
            otherReasonInput.required = false;
            otherReasonInput.value = ''; // Clear the input when not needed
        }
    });

    // Form validation to ensure other reason is filled when "Other" is selected
    document.getElementById('referralForm').addEventListener('submit', function(e) {
        const reason = document.getElementById('reason').value;
        const otherReason = document.getElementById('otherReason').value;
        
        if (reason === 'Other' && (!otherReason || otherReason.trim() === '')) {
            e.preventDefault();
            alert('Please specify the reason for referral when selecting "Other".');
            document.getElementById('otherReason').focus();
        }
    });
</script>

</body>
</html>