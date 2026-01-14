<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.User"%>
<%@ page import="java.util.List"%>
<%
    String userRole = (String) session.getAttribute("userRole");
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
        /* --- Reuse your previous CSS --- */
        body { background: #FFF8E8; font-family: Arial, sans-serif; color: #6B4F36; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; padding-top: 60px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .back-btn { background: #8B7355; color: white; padding: 10px 20px; text-decoration: none; border-radius: 25px; font-weight: bold; display: flex; align-items: center; gap: 8px; }
        .back-btn:hover { background: #6B4F36; }
        h1 { text-align: center; margin-bottom: 5px; font-size: 36px; color: #6B4F36; }
        .subtitle { text-align: center; margin-bottom: 40px; font-size: 18px; color: #CF8224; }
        .profile-card { background: #FFF3C8; border-radius: 20px; padding: 40px; box-shadow: 0 10px 30px rgba(107,79,54,0.15); }
        .filter-bar { margin-bottom: 20px; text-align: center; }
        .filter-btn { padding: 8px 15px; border-radius: 20px; border: none; cursor: pointer; margin: 0 5px; background: #6C5CE7; color: white; }
        .filter-btn.active { background: #5B4BD8; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #E8D4B9; }
        th { background: #FFF3C8; }
        .delete-btn { background: #E74C3C; color: white; border: none; padding: 6px 12px; border-radius: 8px; cursor: pointer; }
        .delete-btn:hover { background: #C0392B; }
        @media (max-width:768px) { table, th, td { font-size: 14px; } }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <a href="${pageContext.request.contextPath}/dashboard" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <h1>Manage Users</h1>
        <div></div>
    </div>

    <div class="subtitle">View and manage all users</div>

    <div class="filter-bar">
        <form method="get">
            <button type="submit" name="filter" value="student" class="filter-btn <%= "student".equals(filter) ? "active" : "" %>">Students</button>
            <button type="submit" name="filter" value="faculty" class="filter-btn <%= "faculty".equals(filter) ? "active" : "" %>">Faculty</button>
            <button type="submit" name="filter" value="professional" class="filter-btn <%= "professional".equals(filter) ? "active" : "" %>">Professionals</button>
            <button type="submit" name="filter" value="admin" class="filter-btn <%= "admin".equals(filter) ? "active" : "" %>">Admins</button>
        </form>
    </div>

    <div class="profile-card">
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
            %>
                <tr id="user-<%= u.getUserId() %>">
                    <td><%= u.getUsername() %></td>
                    <td><%= u.getFullName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getDisplayRole() %></td>
                    <td>
                        <button class="delete-btn" onclick="deleteUser('<%= u.getUserId() %>')">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script>
function deleteUser(userId) {
    if (!confirm('Are you sure you want to delete this user?')) return;

    fetch('deleteUser?userId=' + userId, { method: 'POST' })
        .then(response => response.text())
        .then(data => {
            if (data === 'success') {
                document.getElementById('user-' + userId).remove();
                alert('User deleted successfully');
            } else {
                alert('Failed to delete user');
            }
        })
        .catch(err => alert('Error: ' + err));
}
</script>
</body>
</html>
