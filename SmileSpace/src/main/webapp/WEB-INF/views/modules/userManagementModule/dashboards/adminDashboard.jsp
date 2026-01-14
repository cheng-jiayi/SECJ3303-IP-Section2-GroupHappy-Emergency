<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is an admin
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null || !"admin".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - SmileSpace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #FFF8E8;
            font-family: Arial, sans-serif;
            color: #6B4F36;
            min-height: 100vh;
        }
        .header {
            background: #FFF3C8;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(107, 79, 54, 0.1);
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
        }
        .dropdown.show { display: block; }
        .user-info {
            padding: 15px;
            background: #FFF3C8;
            border-bottom: 2px solid #E8D4B9;
        }
        .user-name { font-weight: bold; }
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
        .menu-item:hover { background: #FFF8E8; }
        .menu-item.logout { color: #E74C3C; }
        .container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .welcome {
            margin-bottom: 40px;
        }
        .welcome h2 {
            color: #D7923B;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
        }
        .card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
        .card-icon {
            width: 80px;
            height: 80px;
            background: #D7923B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: white;
            font-size: 30px;
        }
        .card-title {
            color: #D7923B;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .card-desc {
            color: #8B7355;
            font-size: 14px;
        }
    </style>
</head>
<body>
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
                    <div class="user-role">Administrator</div>
                </div>
                <a href="../profiles/adminProfile.jsp" class="menu-item">
                    <i class="fas fa-user-edit"></i> Manage Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="welcome">
            <h2>Welcome back, <%= userFullName %>!</h2>
            <p>System Administration Dashboard</p>
        </div>
        <div class="card-container">
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/feedback/Analytics'">
                <div class="card-icon">
                    <i class="fas fa-comment-dots"></i>
                </div>
                <div class="card-title">Review Feedback</div>
                <div class="card-desc">View user feedback</div>
            </div>
            
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/admin/manageUsers'">
                <div class="card-icon">
                    <i class="fas fa-users-cog"></i>
                </div>
                <div class="card-title">User Management</div>
                <div class="card-desc">Manage system users</div>
            </div>
            
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/admin/reports'">
                <div class="card-icon">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <div class="card-title">System Reports</div>
                <div class="card-desc">View analytics and reports</div>
            </div>
        </div>
    </div>

    <script>
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
    </script>
</body>
</html>
