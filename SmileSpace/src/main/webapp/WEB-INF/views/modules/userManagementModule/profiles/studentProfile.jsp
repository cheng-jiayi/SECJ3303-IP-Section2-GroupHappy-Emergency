<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is a student
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    String username = (String) session.getAttribute("username");
    String phone = (String) session.getAttribute("phone");
    String email = (String) session.getAttribute("email");
    
    if (userRole == null || !"student".equals(userRole)) {
        response.sendRedirect("../loginPage.jsp");
        return;
    }
    
    // Student-specific data
    String matricNumber = "A23CS0001";
    String programYear = "Computer Science / Year 3";
    
    // Set defaults if session attributes are null
    if (phone == null) phone = "012-3456789";
    if (email == null) email = "student1@graduate.utm.my";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            color: #6B4F36;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding-top: 60px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .back-btn {
            background: #8B7355;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .back-btn:hover {
            background: #6B4F36;
        }
        h1 {
            color: #6B4F36;
            text-align: center;
            margin-bottom: 5px;
            font-size: 36px;
        }
        .subtitle {
            color: #CF8224;
            text-align: center;
            margin-bottom: 40px;
            font-size: 18px;
        }
        .profile-card {
            background: #FFF3C8;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(107, 79, 54, 0.15);
        }
        .profile-header {
            display: flex;
            align-items: center;
            gap: 25px;
            margin-bottom: 40px;
            padding-bottom: 25px;
            border-bottom: 3px solid #E8D4B9;
        }
        .profile-icon {
            width: 100px;
            height: 100px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 40px;
        }
        .profile-info h2 {
            color: #6B4F36;
            font-size: 28px;
            margin-bottom: 5px;
        }
        .user-role {
            background: #D7923B;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            display: inline-block;
        }
        .form-section {
            margin-bottom: 40px;
        }
        .section-title {
            font-size: 22px;
            color: #6B4F36;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E8D4B9;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #6B4F36;
        }
        .input-group {
            position: relative;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-size: 15px;
            background: white;
            color: #6B4F36;
        }
        input:read-only {
            background: #f9f9f9;
            color: #8B7355;
            cursor: not-allowed;
        }
        input:focus {
            outline: none;
            border-color: #D7923B;
        }
        .input-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #D7923B;
        }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #E8D4B9;
        }
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .edit-btn {
            background: #3498DB;
            color: white;
        }
        .edit-btn:hover {
            background: #2980B9;
        }
        .save-btn {
            background: #27AE60;
            color: white;
            display: none;
        }
        .save-btn:hover {
            background: #219653;
        }
        .cancel-btn {
            background: #8B7355;
            color: white;
            display: none;
        }
        .cancel-btn:hover {
            background: #6B4F36;
        }
        .change-password-btn {
            background: #D7923B;
            color: white;
        }
        .change-password-btn:hover {
            background: #C77D2F;
        }
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
            padding: 20px;
        }
        .modal-content {
            background: white;
            border-radius: 20px;
            padding: 30px;
            max-width: 500px;
            width: 100%;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        .modal-header h3 {
            color: #6B4F36;
            font-size: 24px;
            margin: 0;
        }
        .close-modal {
            background: none;
            border: none;
            font-size: 24px;
            color: #6B4F36;
            cursor: pointer;
        }
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .profile-header { flex-direction: column; text-align: center; }
            .form-actions { flex-direction: column; }
            .btn { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="../dashboards/studentDashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            <h1>My Profile</h1>
            <div></div>
        </div>
        
        <div class="subtitle">Manage your personal information and account settings</div>

        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="profile-info">
                    <h2><%= userFullName %></h2>
                    <span class="user-role">Student</span>
                </div>
            </div>

            <form id="profileForm">
                <div class="form-section">
                    <h3 class="section-title">Personal Information</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <div class="input-group">
                                <input type="text" id="username" value="<%= username %>" readonly>
                                <i class="fas fa-user input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <div class="input-group">
                                <input type="text" id="fullName" value="<%= userFullName %>" readonly>
                                <i class="fas fa-id-card input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="matricNumber">Matric Number</label>
                            <div class="input-group">
                                <input type="text" id="matricNumber" value="<%= matricNumber %>" readonly>
                                <i class="fas fa-id-badge input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="programYear">Program / Year</label>
                            <div class="input-group">
                                <input type="text" id="programYear" value="<%= programYear %>" readonly>
                                <i class="fas fa-graduation-cap input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <div class="input-group">
                                <input type="tel" id="phone" value="<%= phone %>" readonly>
                                <i class="fas fa-phone input-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <div class="input-group">
                                <input type="email" id="email" value="<%= email %>" readonly>
                                <i class="fas fa-envelope input-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3 class="section-title">Account Security</h3>
                    <div class="form-group">
                        <button type="button" class="btn change-password-btn" onclick="showPasswordModal()">
                            <i class="fas fa-key"></i> Change Password
                        </button>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn cancel-btn" id="cancelBtn">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="button" class="btn edit-btn" id="editBtn">
                        <i class="fas fa-edit"></i> Edit Profile
                    </button>
                    <button type="button" class="btn save-btn" id="saveBtn">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Password Change Modal -->
    <div class="modal-overlay" id="passwordModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Change Password</h3>
                <button class="close-modal" onclick="hidePasswordModal()">&times;</button>
            </div>
            
            <form id="passwordForm">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" required>
                </div>
                
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" minlength="8" required>
                    <div style="font-size: 12px; color: #8B7355; margin-top: 5px;">
                        Minimum 8 characters
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmNewPassword">Confirm New Password</label>
                    <input type="password" id="confirmNewPassword" minlength="8" required>
                    <div style="font-size: 12px; color: #E74C3C; margin-top: 5px; display: none;" id="passwordMatchError">
                        Passwords do not match
                    </div>
                </div>
                
                <div class="form-actions" style="margin-top: 25px;">
                    <button type="button" class="btn cancel-btn" onclick="hidePasswordModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn save-btn">
                        <i class="fas fa-save"></i> Update Password
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Profile edit functionality
        const editBtn = document.getElementById('editBtn');
        const saveBtn = document.getElementById('saveBtn');
        const cancelBtn = document.getElementById('cancelBtn');
        const editableFields = ['phone', 'email'];
        
        editBtn.addEventListener('click', function() {
            editableFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                field.readOnly = false;
                field.style.background = 'white';
            });
            
            editBtn.style.display = 'none';
            saveBtn.style.display = 'flex';
            cancelBtn.style.display = 'flex';
        });
        
        cancelBtn.addEventListener('click', function() {
            editableFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                field.readOnly = true;
                field.style.background = '#f9f9f9';
                field.value = fieldId === 'phone' ? '<%= phone %>' : '<%= email %>';
            });
            
            editBtn.style.display = 'flex';
            saveBtn.style.display = 'none';
            cancelBtn.style.display = 'none';
        });
        
        saveBtn.addEventListener('click', function() {
            const phone = document.getElementById('phone').value;
            const email = document.getElementById('email').value;
            
            if (!phone.match(/^[0-9]{10,15}$/)) {
                alert('Please enter a valid phone number (10-15 digits)');
                return;
            }
            
            if (!email.match(/^[A-Za-z0-9+_.-]+@(.+)$/)) {
                alert('Please enter a valid email address');
                return;
            }
            
            alert('Profile updated successfully!');
            
            // Update session data (in real app, this would be server-side)
            editableFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                field.readOnly = true;
                field.style.background = '#f9f9f9';
            });
            
            editBtn.style.display = 'flex';
            saveBtn.style.display = 'none';
            cancelBtn.style.display = 'none';
        });
        
        // Password modal functionality
        function showPasswordModal() {
            document.getElementById('passwordModal').style.display = 'flex';
        }
        
        function hidePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
            document.getElementById('passwordForm').reset();
            document.getElementById('passwordMatchError').style.display = 'none';
        }
        
        document.getElementById('confirmNewPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            const errorDiv = document.getElementById('passwordMatchError');
            
            if (confirmPassword && newPassword !== confirmPassword) {
                errorDiv.style.display = 'block';
            } else {
                errorDiv.style.display = 'none';
            }
        });
        
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmNewPassword').value;
            
            if (newPassword !== confirmPassword) {
                alert('New passwords do not match');
                return;
            }
            
            if (newPassword.length < 8) {
                alert('New password must be at least 8 characters long');
                return;
            }
            
            alert('Password changed successfully!');
            hidePasswordModal();
        });
        
        // Close modal when clicking outside
        document.getElementById('passwordModal').addEventListener('click', function(e) {
            if (e.target === this) {
                hidePasswordModal();
            }
        });
    </script>
</body>
</html>