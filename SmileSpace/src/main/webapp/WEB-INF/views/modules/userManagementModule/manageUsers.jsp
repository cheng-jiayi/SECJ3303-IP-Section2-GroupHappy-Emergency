<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.User"%>
<%@ page import="java.util.List"%>
<%
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    if (userRole == null || !"admin".equals(userRole)) {
        response.sendRedirect("../loginPage.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    String filter = (String) request.getAttribute("filter");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users - SmileSpace</title>
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
            max-width: 1200px;
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
        
        /* Filter Bar */
        .filter-bar {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 10px 25px;
            border-radius: 25px;
            border: 2px solid #D7923B;
            background: white;
            color: #6B4F36;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-btn:hover {
            background: #FFF3C8;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(215, 146, 59, 0.2);
        }
        
        .filter-btn.active {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
        }
        
        /* Profile Card / Table Container */
        .profile-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(107, 79, 54, 0.15);
            border: 2px solid #E8D4B9;
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #FFF3C8;
            color: #6B4F36;
            font-weight: 600;
            text-align: left;
            padding: 18px 20px;
            border-bottom: 2px solid #E8D4B9;
            font-size: 16px;
        }
        
        td {
            padding: 18px 20px;
            border-bottom: 1px solid #E8D4B9;
            color: #6B4F36;
        }
        
        tr:hover {
            background: #FFF8E8;
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        /* Role Badge */
        .role-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-block;
        }
        
        .role-student {
            background: #3498DB;
            color: white;
        }
        
        .role-faculty {
            background: #9B59B6;
            color: white;
        }
        
        .role-professional {
            background: #27AE60;
            color: white;
        }
        
        .role-admin {
            background: #E74C3C;
            color: white;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .delete-btn {
            background: #E74C3C;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            font-weight: 600;
            transition: all 0.3s;
            font-size: 14px;
        }
        
        .delete-btn:hover {
            background: #C0392B;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #8B7355;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #E8D4B9;
        }
        
        .empty-state h3 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #D7923B;
        }
        
        .empty-state p {
            font-size: 16px;
            line-height: 1.6;
            max-width: 500px;
            margin: 0 auto;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .container {
                padding: 20px;
            }
            
            .profile-card {
                padding: 25px;
            }
            
            table {
                display: block;
            }
            
            th, td {
                padding: 15px;
            }
        }
        
        @media (max-width: 768px) {
            .header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .logo h1 {
                font-size: 24px;
            }
            
            .filter-bar {
                gap: 10px;
            }
            
            .filter-btn {
                padding: 8px 15px;
                font-size: 14px;
            }
            
            th, td {
                padding: 12px 10px;
                font-size: 14px;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 5px;
            }
        }
        
        @media (max-width: 480px) {
            .welcome h2 {
                font-size: 24px;
            }
            
            .filter-bar {
                flex-direction: column;
                align-items: center;
            }
            
            .filter-btn {
                width: 100%;
                justify-content: center;
            }
            
            .profile-card {
                padding: 20px 15px;
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
                    <div class="user-role">Administrator</div>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="menu-item">
                    <i class="fas fa-home"></i> Dashboard
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
            <h2>Manage Users</h2>
            <p>View and manage all user accounts</p>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar">
            <form method="get" style="display: contents;">
                <button type="submit" name="filter" value="all" class="filter-btn <%= (filter == null || "all".equals(filter)) ? "active" : "" %>">
                    <i class="fas fa-users"></i> All Users
                </button>
                <button type="submit" name="filter" value="student" class="filter-btn <%= "student".equals(filter) ? "active" : "" %>">
                    <i class="fas fa-graduation-cap"></i> Students
                </button>
                <button type="submit" name="filter" value="faculty" class="filter-btn <%= "faculty".equals(filter) ? "active" : "" %>">
                    <i class="fas fa-chalkboard-teacher"></i> Faculty
                </button>
                <button type="submit" name="filter" value="professional" class="filter-btn <%= "professional".equals(filter) ? "active" : "" %>">
                    <i class="fas fa-user-md"></i> Professionals
                </button>
                <button type="submit" name="filter" value="admin" class="filter-btn <%= "admin".equals(filter) ? "active" : "" %>">
                    <i class="fas fa-user-shield"></i> Admins
                </button>
            </form>
        </div>

        <!-- Users Table -->
        <div class="profile-card">
            <%
                if (users == null || users.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="fas fa-users-slash"></i>
                    <h3>No Users Found</h3>
                    <p>There are currently no users matching your filter.</p>
                </div>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (User u : users) {
                            String roleClass = "";
                            switch(u.getRole()) {
                                case "student": roleClass = "role-student"; break;
                                case "faculty": roleClass = "role-faculty"; break;
                                case "professional": roleClass = "role-professional"; break;
                                case "admin": roleClass = "role-admin"; break;
                            }
                    %>
                        <tr id="user-<%= u.getUserId() %>">
                            <td><%= u.getUsername() %></td>
                            <td><%= u.getFullName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <span class="role-badge <%= roleClass %>">
                                    <%= u.getDisplayRole() %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button class="delete-btn" onclick="deleteUser('<%= u.getUserId() %>')">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </div>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>
    </div>

    <script>
        // User dropdown
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

        // Delete user function (kept from original)
        function deleteUser(userId) {
            if (!confirm('Are you sure you want to delete this user? This action cannot be undone.')) return;

            fetch('deleteUser?userId=' + userId, { method: 'POST' })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        document.getElementById('user-' + userId).remove();
                        alert('User deleted successfully');
                        
                        // Check if table is now empty
                        const tableRows = document.querySelectorAll('tbody tr');
                        if (tableRows.length === 0) {
                            location.reload(); // Reload to show empty state
                        }
                    } else {
                        alert('Failed to delete user: ' + data);
                    }
                })
                .catch(err => {
                    alert('Error: ' + err);
                    console.error('Delete error:', err);
                });
        }
    </script>
</body>
</html>
