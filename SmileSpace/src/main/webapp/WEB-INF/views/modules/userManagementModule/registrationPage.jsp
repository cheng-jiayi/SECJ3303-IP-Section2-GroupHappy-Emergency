<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        
        body {
            background: linear-gradient(135deg, #FFF8E8 0%, #FFEEDD 100%);
            font-family: 'Arial', sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .register-container {
            width: 100%;
            max-width: 500px;
        }
        
        .register-card {
            background: white;
            border-radius: 20px;
            padding: 40px 35px;
            box-shadow: 0 15px 35px rgba(107, 79, 54, 0.15);
            border: 1px solid #f0e6d6;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 25px;
        }
        
        .logo h1 {
            color: #D7923B;
            font-size: 36px;
            margin-bottom: 8px;
            font-weight: bold;
        }
        
        .logo p {
            color: #8B7355;
            font-size: 15px;
            letter-spacing: 0.5px;
        }
        
        .card-title {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .card-title h2 {
            color: #6B4F36;
            font-size: 24px;
            margin-bottom: 8px;
        }
        
        .card-title p {
            color: #8B7355;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 22px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #6B4F36;
            font-weight: 600;
            font-size: 14px;
        }
        
        .required:after {
            content: " *";
            color: #E74C3C;
        }
        
        .input-with-icon {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #D7923B;
            font-size: 16px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #E8D4B9;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s;
            background: #fff;
            color: #333;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }
        
        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 22px;
        }
        
        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
        }
        
        .hint {
            font-size: 13px;
            color: #8B7355;
            margin-top: 5px;
            font-style: italic;
        }
        
        .btn-register {
            width: 100%;
            background: #D7923B;
            color: white;
            border: none;
            padding: 16px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-register:hover {
            background: #c77d2f;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(215, 146, 59, 0.3);
        }
        
        .btn-register:active {
            transform: translateY(0);
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
        
        .alert-error {
            background: #FFE8E8;
            color: #d32f2f;
            border-left-color: #d32f2f;
        }
        
        .alert-success {
            background: #E8F5E9;
            color: #2e7d32;
            border-left-color: #2e7d32;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #8B7355;
            cursor: pointer;
            font-size: 16px;
            padding: 0;
        }
        
        /* SIGN IN LINK STYLES */
        .signin-link-container {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #f0e6d6;
        }
        
        .signin-link-container p {
            color: #8B7355;
            font-size: 14px;
            margin-bottom: 12px;
        }
        
        .signin-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #27AE60;
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            border: 2px solid #27AE60;
        }
        
        .signin-link:hover {
            background: white;
            color: #27AE60;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }
        
        .signin-link:active {
            transform: translateY(0);
        }
        
        .footer-text {
            text-align: center;
            margin-top: 20px;
            color: #8B7355;
            font-size: 13px;
            padding-top: 20px;
            border-top: 1px solid #f0e6d6;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-card">
            <div class="logo">
                <h1>SmileSpace</h1>
                <p>Join our wellness community</p>
            </div>
            
            <div class="card-title">
                <h2>Create Your Account</h2>
                <p>Fill in your details to get started</p>
            </div>
            
            <!-- Display server-side messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            </c:if>
            
            <!-- Registration Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
                <!-- Username -->
                <div class="form-group">
                    <label for="username" class="required">Username</label>
                    <div class="input-with-icon">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" id="username" name="username" 
                               class="form-control"
                               placeholder="Choose a username" 
                               pattern="[a-zA-Z0-9]{3,20}" 
                               title="Only letters and numbers, 3-20 characters"
                               required>
                    </div>
                    <div class="hint">Letters and numbers only, 3-20 characters</div>
                </div>
                
                <!-- Phone Number -->
                <div class="form-group">
                    <label for="phone" class="required">Phone Number</label>
                    <div class="input-with-icon">
                        <i class="fas fa-phone input-icon"></i>
                        <input type="tel" id="phone" name="phone" 
                               class="form-control"
                               placeholder="Enter your phone number" 
                               pattern="[0-9]{10,15}" 
                               title="10-15 digits only"
                               required>
                    </div>
                    <div class="hint">Numbers only, no spaces or dashes</div>
                </div>
                
                <!-- Email -->
                <div class="form-group">
                    <label for="email" class="required">Email Address</label>
                    <div class="input-with-icon">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" id="email" name="email" 
                               class="form-control"
                               placeholder="Enter your email" 
                               required>
                    </div>
                    <div class="hint">E.g. email@gmail.com</div>
                </div>
                
                <!-- Password Row -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="password" class="required">Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" 
                                   class="form-control"
                                   placeholder="Password" 
                                   minlength="8" 
                                   required>
                            <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="hint">Minimum 8 characters</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirm" class="required">Confirm Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="confirm" name="confirm" 
                                   class="form-control"
                                   placeholder="Re-enter" 
                                   minlength="8" 
                                   required>
                            <button type="button" class="password-toggle" onclick="togglePassword('confirm')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn-register" id="submitBtn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>
            
            <div class="signin-link-container">
                <p>Already have an account?</p>
                <a href="${pageContext.request.contextPath}/login" class="signin-link">
                    <i class="fas fa-sign-in-alt"></i> Sign In Instead
                </a>
            </div>
            
            <div class="footer-text">
                &copy; 2026 SmileSpace. Digital Mental Health Literacy Hub.
            </div>
        </div>
    </div>
    
    <script>
        // Toggle password visibility
        function togglePassword(fieldId) {
            const passwordField = document.getElementById(fieldId);
            const toggleIcon = passwordField.nextElementSibling.querySelector('i');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
        
        // Form validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('regForm');
            const submitBtn = document.getElementById('submitBtn');
            
            // Real-time password confirmation
            const passwordField = document.getElementById('password');
            const confirmField = document.getElementById('confirm');
            
            function validatePasswords() {
                if (passwordField.value !== confirmField.value) {
                    confirmField.style.borderColor = '#E74C3C';
                    confirmField.style.boxShadow = '0 0 0 3px rgba(231, 76, 60, 0.1)';
                    return false;
                } else {
                    confirmField.style.borderColor = '#27AE60';
                    confirmField.style.boxShadow = '0 0 0 3px rgba(39, 174, 96, 0.1)';
                    return true;
                }
            }
            
            passwordField.addEventListener('input', validatePasswords);
            confirmField.addEventListener('input', validatePasswords);
            
            // Form submission
            form.addEventListener('submit', function(e) {
                const password = passwordField.value;
                const confirm = confirmField.value;
                
                if (password !== confirm) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    return;
                }
                
                if (password.length < 8) {
                    e.preventDefault();
                    alert('Password must be at least 8 characters!');
                    return;
                }
                
                // Show loading state
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
                submitBtn.disabled = true;
                submitBtn.style.background = '#8B7355';
            });
            
            // Clear error messages when user starts typing
            const errorAlert = document.querySelector('.alert-error');
            if (errorAlert) {
                const inputs = document.querySelectorAll('.form-control');
                inputs.forEach(input => {
                    input.addEventListener('input', function() {
                        errorAlert.style.display = 'none';
                    });
                });
            }
            
            // Auto-focus on username field
            document.getElementById('username').focus();
            
            // Improved enter key navigation
            form.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    
                    const fields = [
                        'username', 'phone', 'email', 'password', 'confirm'
                    ];
                    
                    const currentField = document.activeElement.id;
                    const currentIndex = fields.indexOf(currentField);
                    
                    if (currentIndex >= 0 && currentIndex < fields.length - 1) {
                        // Move to next field
                        document.getElementById(fields[currentIndex + 1]).focus();
                    } else if (currentField === 'confirm') {
                        // Submit form from confirm field
                        form.submit();
                    }
                }
            });
        });
    </script>
</body>
</html>
