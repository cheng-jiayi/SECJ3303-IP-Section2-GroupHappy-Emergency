<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - SmileSpace</title>
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
            border-bottom: 3px solid #D7923B;
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
        
        .dropdown.show { 
            display: block; 
        }
        
        .user-info {
            padding: 15px;
            background: #FFF3C8;
            border-bottom: 2px solid #E8D4B9;
        }
        
        .user-name { 
            font-weight: bold; 
        }
        
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
        
        .menu-item:hover { 
            background: #FFF8E8; 
        }
        
        .menu-item.logout { 
            color: #E74C3C; 
        }
        
        /* Main Container */
        .container {
            padding: 40px;
            max-width: 1000px;
            margin: 0 auto;
        }
        
        /* Welcome Section */
        .welcome {
            text-align: center;
            margin-bottom: 40px;
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
        
        /* Profile Card */
        .profile-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(107, 79, 54, 0.15);
            border: 2px solid #E8D4B9;
        }
        
        .profile-header {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 2px solid #E8D4B9;
        }
        
        .profile-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #D7923B, #F5B041);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 40px;
            box-shadow: 0 5px 15px rgba(215, 146, 59, 0.3);
        }
        
        .profile-info h2 {
            color: #6B4F36;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .user-role-badge {
            background: #D7923B;
            color: white;
            padding: 6px 18px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            display: inline-block;
            text-transform: capitalize;
        }
        
        /* Form Sections */
        .form-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 22px;
            color: #D7923B;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #E8D4B9;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #6B4F36;
            font-size: 14px;
        }
        
        .input-group {
            position: relative;
        }
        
        .input-group input {
            width: 100%;
            padding: 14px 45px 14px 15px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-size: 16px;
            background: #FFFEF9;
            color: #6B4F36;
            transition: all 0.3s;
        }
        
        .input-group input:read-only {
            background: #FFF8E8;
            color: #8B7355;
            cursor: not-allowed;
        }
        
        .input-group input:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }
        
        .input-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #D7923B;
            font-size: 16px;
        }
        
        /* Security Section */
        .security-section {
            background: #FFF9E6;
            padding: 25px;
            border-radius: 15px;
            border: 1px solid #FFE8A5;
        }
        
        /* Buttons */
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
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            font-size: 15px;
        }
        
        .edit-btn {
            background: #3498DB;
            color: white;
            border: 2px solid #3498DB;
        }
        
        .edit-btn:hover {
            background: #2980B9;
            border-color: #2980B9;
            transform: translateY(-2px);
        }
        
        .save-btn {
            background: #27AE60;
            color: white;
            border: 2px solid #27AE60;
            display: none;
        }
        
        .save-btn:hover {
            background: #219653;
            border-color: #219653;
            transform: translateY(-2px);
        }
        
        .cancel-btn {
            background: #8B7355;
            color: white;
            border: 2px solid #8B7355;
            display: none;
        }
        
        .cancel-btn:hover {
            background: #6B4F36;
            border-color: #6B4F36;
            transform: translateY(-2px);
        }
        
        .change-password-btn {
            background: #D7923B;
            color: white;
            border: 2px solid #D7923B;
        }
        
        .change-password-btn:hover {
            background: #C77D2F;
            border-color: #C77D2F;
            transform: translateY(-2px);
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
            backdrop-filter: blur(5px);
            z-index: 2000;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .modal-content {
            background: white;
            border-radius: 20px;
            padding: 40px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            border: 2px solid #D7923B;
            animation: modalSlide 0.3s ease;
        }
        
        @keyframes modalSlide {
            from {
                transform: translateY(-30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .modal-header h3 {
            color: #D7923B;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .close-modal {
            background: none;
            border: none;
            font-size: 28px;
            color: #E74C3C;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .close-modal:hover {
            color: #C0392B;
        }
        
        .modal-body input {
            width: 100%;
            padding: 14px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-size: 16px;
            margin-bottom: 20px;
            background: #FFFEF9;
            transition: all 0.3s;
        }
        
        .modal-body input:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }
        
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
        }
        
        .modal-cancel-btn {
            background: #8B7355;
            color: white;
            border: 2px solid #8B7355;
        }
        
        .modal-cancel-btn:hover {
            background: #6B4F36;
            border-color: #6B4F36;
            transform: translateY(-2px);
        }
        
        .modal-save-btn {
            background: #27AE60;
            color: white;
            border: 2px solid #27AE60;
        }
        
        .modal-save-btn:hover {
            background: #219653;
            border-color: #219653;
            transform: translateY(-2px);
        }
        
        .password-match-error {
            font-size: 14px;
            color: #E74C3C;
            margin-top: 5px;
            display: none;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .logo h1 {
                font-size: 24px;
            }
            
            .profile-header {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .modal-content {
                padding: 30px 20px;
            }
        }
        
        @media (max-width: 480px) {
            .profile-card {
                padding: 25px 20px;
            }
            
            .modal-actions {
                flex-direction: column;
            }
            
            .modal-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Header - Consistent with Dashboard -->
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
                    <div class="user-role">
                        <c:choose>
                            <c:when test="${userRole == 'student'}">Student</c:when>
                            <c:when test="${userRole == 'faculty'}">Faculty</c:when>
                            <c:when test="${userRole == 'admin'}">Administrator</c:when>
                            <c:when test="${userRole == 'professional'}">Professional</c:when>
                        </c:choose>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/forum" class="menu-item">
                    <i class="fas fa-users"></i> Peer Support Forum
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                    <i class="fas fa-user-edit"></i> My Profile
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
            <h2>My Profile</h2>
            <p>Manage your personal information and account settings</p>
        </div>

        <div class="profile-card">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="profile-info">
                    <h2>${user.fullName}</h2>
                    <span class="user-role-badge">
                        <c:choose>
                            <c:when test="${userRole == 'student'}">Student</c:when>
                            <c:when test="${userRole == 'faculty'}">Faculty Member</c:when>
                            <c:when test="${userRole == 'admin'}">Administrator</c:when>
                            <c:when test="${userRole == 'professional'}">Mental Health Professional</c:when>
                            <c:otherwise>User</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <!-- Profile Form -->
            <form id="profileForm" action="${pageContext.request.contextPath}/profile/update" method="post">
                <!-- Personal Information Section -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-user-circle"></i> Personal Information
                    </h3>
                    <div class="form-grid">
                        <!-- Username -->
                        <div class="form-group">
                            <label for="username">Username</label>
                            <div class="input-group">
                                <input type="text" name="username" value="${user.username}" readonly>
                                <i class="fas fa-user input-icon"></i>
                            </div>
                        </div>
                        
                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <div class="input-group">
                                <input type="text" name="fullName" value="${user.fullName}" readonly>
                                <i class="fas fa-id-card input-icon"></i>
                            </div>
                        </div>
                        
                        <!-- Student-specific fields -->
                        <c:if test="${userRole == 'student'}">
                            <div class="form-group">
                                <label for="matricNumber">Matric Number</label>
                                <div class="input-group">
                                    <input type="text" name="matricNumber" value="${user.matricNumber}" readonly>
                                    <i class="fas fa-id-badge input-icon"></i>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="faculty">faculty</label>
                                <div class="input-group">
                                    <input type="text" name="faculty" value="${user.faculty}" readonly>
                                    <i class="fas fa-graduation-cap input-icon"></i>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="year">Year</label>
                                <div class="input-group">
                                    <input type="number" name="year" value="${user.year}" readonly>
                                    <i class="fas fa-calendar input-icon"></i>
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- Contact Information -->
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <div class="input-group">
                                <input type="tel" name="phone" value="${user.phone}" readonly>
                                <i class="fas fa-phone input-icon"></i>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <div class="input-group">
                                <input type="email" name="email" value="${user.email}" readonly>
                                <i class="fas fa-envelope input-icon"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Security Section -->
                <div class="form-section security-section">
                    <h3 class="section-title">
                        <i class="fas fa-shield-alt"></i> Account Security
                    </h3>
                    <button type="button" class="btn change-password-btn" onclick="showPasswordModal()">
                        <i class="fas fa-key"></i> Change Password
                    </button>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn cancel-btn" id="cancelBtn">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="button" class="btn edit-btn" id="editBtn">
                        <i class="fas fa-edit"></i> Edit Profile
                    </button>
                    <button type="submit" class="btn save-btn" id="saveBtn">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div class="modal" id="passwordModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-key"></i> Change Password</h3>
                <button class="close-modal" onclick="hidePasswordModal()">&times;</button>
            </div>
            <form id="passwordForm" action="${pageContext.request.contextPath}/profile/change-password" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" name="newPassword" id="newPassword" 
                               placeholder="Enter new password (min. 8 characters)" 
                               minlength="8" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmNewPassword">Confirm New Password</label>
                        <input type="password" id="confirmNewPassword" 
                               placeholder="Re-enter new password" 
                               minlength="8" required>
                        <div class="password-match-error" id="passwordMatchError">
                            <i class="fas fa-exclamation-circle"></i> Passwords do not match
                        </div>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn modal-cancel-btn" onclick="hidePasswordModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn modal-save-btn">
                        <i class="fas fa-save"></i> Update Password
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // User dropdown (same as dashboard/forum)
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
        
        // Profile form functionality
        const editBtn = document.getElementById('editBtn');
        const saveBtn = document.getElementById('saveBtn');
        const cancelBtn = document.getElementById('cancelBtn');
        
        // Fields that can be edited
        const editableFields = ['fullName', 'phone', 'email'];
        <c:if test="${userRole == 'student'}">
            editableFields.push('matricNumber', 'faculty', 'year');
        </c:if>
        
        // Enable editing
        editBtn.addEventListener('click', function() {
            editableFields.forEach(fieldName => {
                const field = document.querySelector(`input[name="${fieldName}"]`);
                if (field) {
                    field.readOnly = false;
                    field.style.background = '#FFFEF9';
                    field.style.color = '#6B4F36';
                }
            });
            
            editBtn.style.display = 'none';
            saveBtn.style.display = 'flex';
            cancelBtn.style.display = 'flex';
        });
        
        // Cancel editing
        cancelBtn.addEventListener('click', function() {
            editableFields.forEach(fieldName => {
                const field = document.querySelector(`input[name="${fieldName}"]`);
                if (field) {
                    field.readOnly = true;
                    field.style.background = '#FFF8E8';
                    field.style.color = '#8B7355';
                }
            });
            
            editBtn.style.display = 'flex';
            saveBtn.style.display = 'none';
            cancelBtn.style.display = 'none';
        });
        
        // Password modal functions
        function showPasswordModal() { 
            document.getElementById('passwordModal').style.display = 'flex'; 
        }
        
        function hidePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
            document.getElementById('passwordForm').reset();
            document.getElementById('passwordMatchError').style.display = 'none';
        }
        
        // Real-time password validation
        const newPasswordField = document.getElementById('newPassword');
        const confirmPasswordField = document.getElementById('confirmNewPassword');
        const passwordError = document.getElementById('passwordMatchError');
        
        function validatePasswords() {
            if (confirmPasswordField.value && newPasswordField.value !== confirmPasswordField.value) {
                passwordError.style.display = 'block';
                confirmPasswordField.style.borderColor = '#E74C3C';
                confirmPasswordField.style.boxShadow = '0 0 0 3px rgba(231, 76, 60, 0.1)';
                return false;
            } else {
                passwordError.style.display = 'none';
                confirmPasswordField.style.borderColor = '#27AE60';
                confirmPasswordField.style.boxShadow = '0 0 0 3px rgba(39, 174, 96, 0.1)';
                return true;
            }
        }
        
        newPasswordField.addEventListener('input', validatePasswords);
        confirmPasswordField.addEventListener('input', validatePasswords);
        
        // Password form submission
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            if (!validatePasswords()) {
                e.preventDefault();
                alert('Please make sure your passwords match before submitting.');
            }
        });
        
        // Close modal when clicking outside
        document.getElementById('passwordModal').addEventListener('click', function(e) {
            if (e.target === this) hidePasswordModal();
        });
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                hidePasswordModal();
            }
        });
        
        // Form validation feedback
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            const emailField = document.querySelector('input[name="email"]');
            const phoneField = document.querySelector('input[name="phone"]');
            
            // Validate email format
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailField.value)) {
                e.preventDefault();
                emailField.style.borderColor = '#E74C3C';
                alert('Please enter a valid email address.');
                return;
            }
            
            // Validate phone number (basic check)
            const phoneRegex = /^[0-9]{10,15}$/;
            if (!phoneRegex.test(phoneField.value)) {
                e.preventDefault();
                phoneField.style.borderColor = '#E74C3C';
                alert('Phone number should contain 10-15 digits only.');
                return;
            }
        });
    </script>
</body>
</html>
