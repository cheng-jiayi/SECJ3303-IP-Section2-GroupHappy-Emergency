<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="smilespace.model.LearningModule" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    LearningModule module = (LearningModule) request.getAttribute("module");
    String userRole = (String) request.getAttribute("userRole");
    List<Map<String, Object>> accessHistory = (List<Map<String, Object>>) request.getAttribute("accessHistory");
    
    if (module == null) {
        response.sendRedirect("admin-module-dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Module - <%= module.getTitle() %></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Fredoka', sans-serif; 
        }
        
        body { 
            background: #FBF6EA; 
            color: #713C0B; 
            min-height: 100vh;
        }
        
        /* Top Navigation */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .container { 
            max-width: 1200px; 
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* Page Title */
        .page-title {
            text-align: left;
            margin-bottom: 30px;
        }
        
        .page-title h1 {
            font-size: 32px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 10px;
        }
        
        .page-title p {
            font-size: 16px;
            color: #713C0B;
            opacity: 0.9;
        }
        
        /* Content */
        .content { 
            background: white; 
            border-radius: 20px; 
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border: 2px solid #F0D5B8;
            margin-top: 10px;
        }
        
        /* Back Link */
        .back-link { 
            display: inline-flex; 
            align-items: center; 
            gap: 8px;
            margin-bottom: 25px; 
            color: #713C0B; 
            text-decoration: none; 
            font-weight: 500;
            padding: 10px 20px;
            border-radius: 10px;
            background: #F4DBAF;
            border: 2px solid #713C0B;
            transition: all 0.3s;
        }
        
        .back-link:hover { 
            background: #713C0B; 
            color: #FBF6EA;
            transform: translateX(-3px);
        }
        
        /* Module Info */
        .module-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 768px) {
            .module-info {
                grid-template-columns: 1fr;
            }
        }
        
        .info-card {
            background: #FFF9F0;
            border-radius: 15px;
            padding: 25px;
            border: 2px solid #F0D5B8;
        }
        
        .info-title {
            color: #F0A548;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-detail {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #F0D5B8;
        }
        
        .detail-label {
            font-weight: 600;
            color: #713C0B;
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .detail-value {
            color: #8B7355;
            font-size: 16px;
        }
        
        .module-id-badge {
            display: inline-block;
            background: #F0A548;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .module-title {
            color: #713C0B;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        /* Badges */
        .badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-transform: capitalize;
        }
        
        .stress { background: #FFE0E0; color: #C73737; }
        .sleep { background: #D7F7F7; color: #2A8989; }
        .anxiety { background: #FFF4C8; color: #B88414; }
        .self-esteem { background: #D1EBFF; color: #106C9E; }
        .mindfulness { background: #CFFFE5; color: #17926E; }
        
        .level-beginner { background: #4ECDC4; color: white; }
        .level-intermediate { background: #FFD166; color: #713C0B; }
        .level-advance { background: #EF476F; color: white; }
        
        /* Stats */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .stat-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            border: 2px solid #F0D5B8;
            text-align: center;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 13px;
            color: #8B7355;
        }
        
        /* File Links */
        .file-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #F0A548;
            text-decoration: none;
            font-weight: 500;
            background: #FFF3C8;
            padding: 8px 15px;
            border-radius: 8px;
            border: 1px solid #F0A548;
            transition: all 0.3s;
        }
        
        .file-link:hover {
            background: #F0A548;
            color: white;
            text-decoration: none;
        }
        
        /* Access History */
        .access-history {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #F0D5B8;
        }
        
        .history-table {
            overflow-x: auto;
            margin-top: 15px;
        }
        
        .history-table table {
            width: 100%;
            border-collapse: collapse;
            background: #FFF9F0;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .history-table th {
            background: #F0A548;
            color: white;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
        }
        
        .history-table td {
            padding: 10px 15px;
            border-bottom: 1px solid #F0D5B8;
            color: #713C0B;
        }
        
        .history-table tr:hover {
            background: #F9EEDB;
        }
        
        .access-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .access-badge.view { background: #D1EBFF; color: #106C9E; }
        .access-badge.edit { background: #FFF4C8; color: #B88414; }
        .access-badge.create { background: #CFFFE5; color: #17926E; }
        
        /* Button Group */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #F0D5B8;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #F0A548;
            color: white;
        }
        
        .btn-primary:hover {
            background: #D18A2C;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #F0D5B8;
            color: #713C0B;
            border: 2px solid #713C0B;
        }
        
        .btn-secondary:hover {
            background: #713C0B;
            color: #FBF6EA;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 30px;
            color: #8B7355;
            background: #FFF9F0;
            border-radius: 10px;
            border: 2px dashed #F0D5B8;
        }
        
        .empty-state i {
            font-size: 40px;
            margin-bottom: 15px;
            color: #F0D5B8;
        }
    </style>
</head>
<body>
    <!-- Top Navigation -->
    <div class="top-nav">
        <div class="logo">
            <i class="fas fa-home"></i>
            SmileSpace
        </div>
    </div>
    
    <div class="container">
        <!-- Page Title -->
        <div class="page-title">
            <h1>Module Details</h1>
            <p>View learning module information</p>
        </div>
        
        <div class="content">
            
            <!-- Module Basic Info -->
            <div class="module-info">
                <div class="info-card">
                    <div class="info-title">
                        <i class="fas fa-info-circle"></i>
                        Basic Information
                    </div>
                    
                    <div class="module-id-badge">
                        <%= module.getId() %>
                    </div>
                    
                    <div class="module-title">
                        <%= module.getTitle() %>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Category</div>
                        <div class="detail-value">
                            <span class="badge <%= module.getCategory().toLowerCase().replace(" ", "-") %>">
                                <%= module.getCategory() %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Learning Level</div>
                        <div class="detail-value">
                            <%
                                String displayLevel = module.getLevel();
                                if ("Advance".equals(displayLevel)) {
                                    displayLevel = "Advanced";
                                }
                            %>
                            <span class="badge level-<%= module.getLevel().toLowerCase() %>">
                                <%= displayLevel %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Author</div>
                        <div class="detail-value">
                            <%= module.getAuthorName() != null && !module.getAuthorName().isEmpty() ? 
                                module.getAuthorName() : "Not specified" %>
                        </div>
                    </div>
                    
                    <div class="info-detail">
                        <div class="detail-label">Estimated Duration</div>
                        <div class="detail-value">
                            <%= module.getEstimatedDuration() != null && !module.getEstimatedDuration().isEmpty() ? 
                                module.getEstimatedDuration() : "Not specified" %>
                        </div>
                    </div>

                    <!-- Content Outline -->
                    <% if (module.getContentOutline() != null && !module.getContentOutline().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Content Outline</div>
                        <div class="detail-value">
                            <ul style="padding-left: 20px;">
                                <% 
                                    String[] outlinePoints = module.getContentOutlineArray();
                                    for (String point : outlinePoints) {
                                        if (!point.trim().isEmpty()) {
                                %>
                                <li><%= point.trim() %></li>
                                <%      }
                                    } 
                                %>
                            </ul>
                        </div>
                    </div>
                    <% } %>

                    <!-- Learning Guide -->
                    <% if (module.getLearningGuide() != null && !module.getLearningGuide().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Learning Guide</div>
                        <div class="detail-value">
                            <ol style="padding-left: 20px;">
                                <% 
                                    String[] guideSteps = module.getLearningGuideArray();
                                    int stepNumber = 1;
                                    for (String step : guideSteps) {
                                        if (!step.trim().isEmpty()) {
                                %>
                                <li><%= step.trim() %></li>
                                <%      
                                            stepNumber++;
                                        }
                                    } 
                                %>
                            </ol>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <div class="info-card">
                    <div class="info-title">
                        <i class="fas fa-chart-bar"></i>
                        Statistics & Resources
                    </div>
                    
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-value"><%= module.getViews() %></div>
                            <div class="stat-label">Total Views</div>
                        </div>
                        
                        <div class="stat-item">
                            <div class="stat-value">
                                <%= module.getLastUpdated() != null ? module.getLastUpdated() : "N/A" %>
                            </div>
                            <div class="stat-label">Last Updated</div>
                        </div>
                    </div>
                    
                    <div class="info-detail" style="margin-top: 20px;">
                        <div class="detail-label">Description</div>
                        <div class="detail-value" style="line-height: 1.6;">
                            <%= module.getDescription() != null && !module.getDescription().isEmpty() ? 
                                module.getDescription() : 
                                "<div class='empty-state' style='padding: 10px; font-size: 14px;'>No description available</div>" %>
                        </div>
                    </div>
                    
                    <% if (module.getCoverImage() != null && !module.getCoverImage().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Cover Image</div>
                        <div class="detail-value">
                            <a href="<%= module.getCoverImage() %>" class="file-link" target="_blank">
                                <i class="fas fa-image"></i>
                                View Cover Image
                            </a>
                        </div>
                    </div>
                    <% } %>
                    
                    <% if (module.getResourceFile() != null && !module.getResourceFile().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Resource File</div>
                        <div class="detail-value">
                            <a href="<%= module.getResourceFile() %>" class="file-link" target="_blank">
                                <i class="fas fa-file-download"></i>
                                Download Resource
                            </a>
                        </div>
                    </div>
                    <% } %>

                    <!-- Video URL -->
                    <% if (module.getVideoUrl() != null && !module.getVideoUrl().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Video Instruction</div>
                        <div class="detail-value">
                            <a href="<%= module.getVideoUrl() %>" class="file-link" target="_blank">
                                <i class="fas fa-video"></i>
                                Watch Video
                            </a>
                        </div>
                    </div>
                    <% } %>

                    <!-- Learning Tip -->
                    <% if (module.getLearningTip() != null && !module.getLearningTip().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Learning Tip</div>
                        <div class="detail-value" style="background: #FFF3C8; padding: 10px; border-radius: 8px;">
                            <i class="fas fa-lightbulb" style="color: #F0A548;"></i>
                            <%= module.getLearningTip() %>
                        </div>
                    </div>
                    <% } %>

                    <!-- Key Points -->
                    <% if (module.getKeyPoints() != null && !module.getKeyPoints().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Key Points</div>
                        <div class="detail-value">
                            <div style="display: flex; flex-wrap: wrap; gap: 10px;">
                                <% 
                                    String[] keyPointArray = module.getKeyPointsArray();
                                    for (String keyPoint : keyPointArray) {
                                        if (!keyPoint.trim().isEmpty()) {
                                %>
                                <span style="background: #E8F4FC; padding: 6px 12px; border-radius: 15px; 
                                            border: 1px solid #A7C7E7; color: #106C9E; font-size: 14px;">
                                    <i class="fas fa-check-circle" style="margin-right: 5px;"></i>
                                    <%= keyPoint.trim() %>
                                </span>
                                <%      }
                                    } 
                                %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                    
                    <% if (module.getNotes() != null && !module.getNotes().isEmpty()) { %>
                    <div class="info-detail">
                        <div class="detail-label">Additional Notes</div>
                        <div class="detail-value" style="background: #FFF3C8; padding: 10px; border-radius: 8px;">
                            <%= module.getNotes() %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Access History (for admins/faculty only) -->
            <% if (("admin".equals(userRole) || "faculty".equals(userRole)) && accessHistory != null && !accessHistory.isEmpty()) { %>
            <div class="access-history">
                <div class="info-title">
                    <i class="fas fa-history"></i>
                    Access History (Last 50)
                </div>
                
                <div class="history-table">
                    <table>
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Access Type</th>
                                <th>Date & Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> record : accessHistory) { %>
                            <tr>
                                <td>
                                    <strong><%= record.get("userName") %></strong><br>
                                    <small>@<%= record.get("username") %></small>
                                </td>
                                <td>
                                    <span class="access-badge <%= record.get("accessType") %>">
                                        <%= record.get("accessType") %>
                                    </span>
                                </td>
                                <td>
                                    <%= record.get("accessDate") %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } %>
            
            <!-- Action Buttons -->
            <div class="button-group">
                <a href="admin-module-dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Back to Dashboard
                </a>
                
                <% if ("admin".equals(userRole) || "faculty".equals(userRole)) { %>
                <a href="edit-module?id=<%= module.getId() %>" class="btn btn-primary">
                    <i class="fas fa-edit"></i>
                    Edit Module
                </a>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        // Format date display if needed
        document.addEventListener('DOMContentLoaded', function() {
            // Add any client-side functionality here
        });
    </script>
</body>
</html>