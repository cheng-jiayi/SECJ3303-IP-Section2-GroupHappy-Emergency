<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - SmileSpace</title>
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
        
        .login-container {
            width: 100%;
            max-width: 420px;
        }
        
        .login-card {
            background: white;
            border-radius: 20px;
            padding: 40px 35px;
            box-shadow: 0 15px 35px rgba(107, 79, 54, 0.15);
            border: 1px solid #f0e6d6;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 30px;
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
        
        .btn-login {
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
        
        .btn-login:hover {
            background: #c77d2f;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(215, 146, 59, 0.3);
        }
        
        .btn-login:active {
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
            display: none;
        }
        
        .alert-error {
            background: #FFE8E8;
            color: #d32f2f;
            border-left-color: #d32f2f;
            display: block;
        }
        
        .alert-success {
            background: #E8F5E9;
            color: #2e7d32;
            border-left-color: #2e7d32;
            display: block;
        }
        
        .demo-accounts {
            margin-top: 30px;
            padding: 20px;
            background: #FFF9E6;
            border-radius: 12px;
            font-size: 14px;
            border: 1px solid #FFE8A5;
        }
        
        .demo-accounts h3 {
            color: #D7923B;
            margin-bottom: 12px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .demo-accounts ul {
            list-style: none;
            padding-left: 0;
        }
        
        .demo-accounts li {
            margin-bottom: 8px;
            color: #6B4F36;
            padding-left: 20px;
            position: relative;
        }
        
        .demo-accounts li:before {
            content: "→";
            position: absolute;
            left: 0;
            color: #D7923B;
            font-weight: bold;
        }
        
        .demo-accounts strong {
            color: #D7923B;
            font-weight: 600;
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
        
        /* SIGN UP LINK STYLES */
        .signup-link-container {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #f0e6d6;
        }
        
        .signup-link-container p {
            color: #8B7355;
            font-size: 14px;
            margin-bottom: 12px;
        }
        
        .signup-link {
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
        
        .signup-link:hover {
            background: white;
            color: #27AE60;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.2);
        }
        
        .signup-link:active {
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
    <div class="login-container">
        <div class="login-card">
            <div class="logo">
                <h1>SmileSpace</h1>
                <p>Mental Wellness Platform</p>
            </div>
            
            <%-- Error Message --%>
            <% 
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                String logout = request.getParameter("logout");
                
                if (error != null && !error.isEmpty()) { 
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>
            
            <% if (success != null && !success.isEmpty()) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= success %>
                </div>
            <% } %>
            
            <% if ("success".equals(logout)) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> You have been successfully logged out.
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-with-icon">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" id="username" name="username" class="form-control" 
                               placeholder="Enter your username" required autocomplete="username"
                               value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-with-icon">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Enter your password" required autocomplete="current-password">
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                
                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i> Login to SmileSpace
                </button>
            </form>
            
            <div class="demo-accounts">
                <h3><i class="fas fa-users"></i> Demo Accounts</h3>
                <ul>
                    <li><strong>Student:</strong> student1 / password123</li>
                    <li><strong>Faculty:</strong> faculty1 / password123</li>
                    <li><strong>Admin:</strong> admin1 / password123</li>
                    <li><strong>Professional:</strong> mhp1 / password123</li>
                </ul>
            </div>

            <div class="signup-link-container">
                <p>Don't have an account?</p>
                <a href="${pageContext.request.contextPath}/register" class="signup-link">
                    <i class="fas fa-user-plus"></i> Sign Up Now
                </a>
            </div>
            
            <div class="footer-text">
                &copy; 2024 SmileSpace. Student Mental Wellness Platform.
            </div>
        </div>
    </div>
    
    <script>
        // Toggle password visibility
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const toggleIcon = document.querySelector('.password-toggle i');
            
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
        
        // Clear error message when user starts typing
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.form-control');
            const errorAlert = document.querySelector('.alert-error');
            
            if (errorAlert) {
                inputs.forEach(input => {
                    input.addEventListener('input', function() {
                        errorAlert.style.display = 'none';
                    });
                });
            }
            
            // Auto-focus on username field
            document.getElementById('username').focus();
            
            // Enter key submits form
            document.addEventListener('keypress', function(e) {
                if (e.key === 'Enter' && e.target.matches('.form-control')) {
                    document.querySelector('form').submit();
                }
            });
        });

        // Prevent form submission on Enter key
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const usernameField = document.getElementById('username');
            const passwordField = document.getElementById('password');
            
            // Prevent Enter key from submitting form unless in password field
            form.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    
                    // If Enter pressed in username field, move to password field
                    if (document.activeElement === usernameField) {
                        passwordField.focus();
                    }
                    // If Enter pressed in password field, submit form
                    else if (document.activeElement === passwordField) {
                        form.submit();
                    }
                }
            });
            
            // Only allow form submission when button is clicked
            form.addEventListener('submit', function(e) {
                const submitter = e.submitter;
                if (!submitter || submitter.type !== 'submit') {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
