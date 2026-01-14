<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    if (module == null) {
        response.sendRedirect("dashboard?error=module_not_found");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Learning Module - SmileSpace</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<!DOCTYPE html>
<html>
<head>
    <title>UC005 - Delete Module</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Preahvihear', sans-serif; }
        body { background: #FBF6EA; color: #713C0B; }
        
        .container { max-width: 800px; margin: 40px auto; background: white; border-radius: 15px; box-shadow: 0 8px 25px rgba(107, 79, 54, 0.1); overflow: hidden; }
        .header { background: linear-gradient(135deg, #FF6B6B 0%, #FF8E8E 100%); color: white; padding: 30px; text-align: center; }
        .header h1 { font-size: 28px; font-weight: 600; }
        
        .content { padding: 35px; text-align: center; }
        
        .back-link { 
            display: inline-flex; align-items: center; gap: 8px; margin-bottom: 25px; 
            color: #713C0B; text-decoration: none; font-weight: 500; font-size: 15px;
            padding: 8px 16px; border-radius: 20px; background: #F4DBAF; transition: all 0.3s;
        }
        .back-link:hover { background: #F0A548; text-decoration: none; color: white; }
        
        .warning-icon { font-size: 80px; color: #FF6B6B; margin-bottom: 20px; }
        
        h2 { color: #713C0B; margin-bottom: 15px; font-size: 24px; }
        p { color: #CF8224; margin-bottom: 30px; font-size: 16px; }
        
        .module-info { background: #FFF3C8; padding: 25px; border-radius: 12px; margin: 30px 0; text-align: left; border-left: 5px solid #FF6B6B; }
        .module-info h3 { margin-bottom: 20px; color: #713C0B; font-size: 20px; padding-bottom: 10px; border-bottom: 2px solid #F0A548; }
        .module-detail { display: flex; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px dashed #F0A548; }
        .detail-label { font-weight: 600; width: 160px; color: #713C0B; }
        .detail-value { flex: 1; color: #8B7355; }
        .detail-value strong { color: #CF8224; }
        
        .warning-text { background: #FFE8E8; padding: 20px; border-radius: 10px; margin: 25px 0; border: 2px solid #FF6B6B; }
        .warning-text h4 { color: #E74C3C; margin-bottom: 10px; font-size: 18px; display: flex; align-items: center; gap: 10px; }
        
        .button-group { display: flex; gap: 20px; justify-content: center; margin-top: 35px; }
        .btn { padding: 14px 35px; border: none; border-radius: 10px; font-weight: 600; font-size: 16px; cursor: pointer; transition: all 0.3s; }
        .btn-danger { background: linear-gradient(135deg, #FF6B6B 0%, #E74C3C 100%); color: white; }
        .btn-danger:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3); }
        .btn-secondary { background: #713C0B; color: white; }
        .btn-secondary:hover { background: #5A2F09; transform: translateY(-3px); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>UC005 - Delete Module</h1>
        </div>
        
        <div class="content">
            
            <div class="warning-icon">⚠️</div>
            <h2>Do you really want to delete this module?</h2>
            <p>Once deleted, it will be permanently removed from the system.</p>
            
            <div class="module-info">
                <h3>Module Information</h3>
                <div class="module-detail">
                    <div class="detail-label">ID:</div>
                    <div class="detail-value"><strong><%= module.getId() %></strong></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Title:</div>
                    <div class="detail-value"><%= module.getTitle() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Category:</div>
                    <div class="detail-value"><%= module.getCategory() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Learning Level:</div>
                    <div class="detail-value"><%= module.getLevel() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Views:</div>
                    <div class="detail-value"><%= module.getViews() %></div>
                </div>
                <div class="module-detail">
                    <div class="detail-label">Last Updated:</div>
                    <div class="detail-value"><%= module.getLastUpdated() %></div>
                </div>
            </div>
            
            <div class="warning-text">
                <h4>⚠️ Warning</h4>
                <p>This action cannot be undone. All associated data including cover images, resource files, and usage statistics will be permanently deleted.</p>
            </div>
            
            <div class="button-group">
                <form action="delete-module" method="POST" style="display: inline;">
                    <input type="hidden" name="id" value="<%= module.getId() %>">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='admin-module-dashboard'">Cancel</button>
                    <button type="submit" class="btn btn-danger">Confirm Delete</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>