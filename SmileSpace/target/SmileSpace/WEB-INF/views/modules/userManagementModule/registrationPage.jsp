<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - SmileSpace</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            width: 100%;
            max-width: 500px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo h1 {
            color: #D7923B;
            font-size: 42px;
            margin-bottom: 10px;
        }
        .card {
            background: #FFF3C8;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(107, 79, 54, 0.15);
        }
        .card h2 {
            color: #6B4F36;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            color: #6B4F36;
            font-weight: bold;
            margin-bottom: 8px;
        }
        label.required:after {
            content: " *";
            color: #E74C3C;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-size: 16px;
        }
        input:focus {
            outline: none;
            border-color: #D7923B;
        }
        .btn {
            width: 100%;
            padding: 14px;
            background: #D7923B;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn:hover {
            background: #C77D2F;
        }
        .link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #E8D4B9;
        }
        .link a {
            display: block;
            background: #8B7355;
            color: white;
            padding: 12px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }
        .link a:hover {
            background: #6B4F36;
        }
        .error {
            background: #FFE8E6;
            color: #E74C3C;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        .success {
            background: #E6FFE8;
            color: #27AE60;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        .row {
            display: flex;
            gap: 15px;
        }
        .row .form-group {
            flex: 1;
        }
        .hint {
            font-size: 12px;
            color: #888;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <h1>SmileSpace</h1>
            <p>Join our wellness community</p>
        </div>
        
        <div class="card">
            <h2>Create Your Account</h2>

            <!-- Display server-side messages -->
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="success">${success}</div>
            </c:if>
            
            <!-- Registration Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
                <div class="form-group">
                    <label for="username" class="required">Username</label>
                    <input type="text" id="username" name="username" 
                           placeholder="3-20 letters/numbers" 
                           pattern="[a-zA-Z0-9]{3,20}" required>
                    <div class="hint">Letters and numbers only</div>
                </div>
                
                <div class="form-group">
                    <label for="phone" class="required">Phone Number</label>
                    <input type="tel" id="phone" name="phone" 
                           placeholder="10-15 digits" 
                           pattern="[0-9]{10,15}" required>
                    <div class="hint">Numbers only, no spaces/dashes</div>
                </div>
                
                <div class="form-group">
                    <label for="email" class="required">Email</label>
                    <input type="email" id="email" name="email" 
                           placeholder="your@email.com" required>
                </div>
                
                <div class="row">
                    <div class="form-group">
                        <label for="password" class="required">Password</label>
                        <input type="password" id="password" name="password" 
                               placeholder="Min. 8 characters" minlength="8" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirm" class="required">Confirm Password</label>
                        <input type="password" id="confirm" name="confirm" 
                               placeholder="Re-enter password" minlength="8" required>
                    </div>
                </div>
                
                <button type="submit" class="btn" id="submitBtn">Create Account</button>
            </form>
            
            <div class="link">
                <p>Already have an account?</p>
                <a href="${pageContext.request.contextPath}/login">Sign In Instead</a>
            </div>
        </div>
    </div>
    
    <script>
        document.getElementById('regForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirm = document.getElementById('confirm').value;
            
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
            document.getElementById('submitBtn').innerHTML = 'Creating Account...';
            document.getElementById('submitBtn').disabled = true;
        });
    </script>
</body>
</html>
