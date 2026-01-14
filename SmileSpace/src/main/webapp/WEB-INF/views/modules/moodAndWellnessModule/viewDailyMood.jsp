<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.MoodEntry" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    String dateParam = request.getParameter("date");
    MoodEntry dailyMood = (MoodEntry) request.getAttribute("dailyMood");
    
    if (dailyMood == null) {
        // If no mood found, show empty state or redirect
        response.sendRedirect(request.getContextPath() + "/mood?action=viewTrends");
        return;
    }
    
    LocalDate moodDate = dailyMood.getEntryDate();
    DateTimeFormatter displayFormat = DateTimeFormatter.ofPattern("d MMM yyyy");
    
    // Get the image path if it exists
    String imagePath = dailyMood.getImagePath();
    boolean hasImage = imagePath != null && !imagePath.trim().isEmpty();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Daily Mood - <%= moodDate.format(displayFormat) %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body {
            font-family: 'Preahvihear', sans-serif;
            background: #FFF8E8;
            margin: 0;
            padding: 0;
            color: #6B4F36;
        }

        .container {
            width: 80%;
            margin: auto;
            padding: 30px 0;
        }

        .top-right {
            position: absolute;
            right: 40px;
            top: 20px;
            font-size: 20px;
            font-weight: bold;
        }

        .home-link {
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: #6B4F36;
            transition: opacity 0.2s;
        }

        .home-link:hover {
            opacity: 0.7;
            text-decoration: none;
        }

        h1 {
            color: #6B4F36;
            font-size: 36px;
            font-weight: 600;
        }

        .daily-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .daily-date {
            font-size: 24px;
            font-weight: 600;
            color: #6B4F36;
        }

        .mood-details {
            background: #FFF3C8;
            padding: 25px;
            border-radius: 15px;
            margin: 20px 0;
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
        }

        .mood-content {
            flex: 1;
            min-width: 300px;
        }

        .detail-row {
            margin-bottom: 15px;
            display: flex;
        }

        .detail-label {
            font-weight: 600;
            width: 120px;
            color: #6B4F36;
        }

        .detail-value {
            flex: 1;
            color: #8B7355;
        }

        /* Image Preview Section */
        .image-section {
            flex: 0 0 300px;
        }

        .image-container {
            background: white;
            border-radius: 15px;
            padding: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .image-preview {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 2px solid #E8D4B9;
        }

        .no-image {
            width: 100%;
            height: 250px;
            background: #F5F5F5;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #8B7355;
            border: 2px dashed #D4A46D;
        }

        .no-image i {
            font-size: 50px;
            margin-bottom: 15px;
            color: #D4A46D;
        }

        .image-label {
            font-weight: 600;
            color: #6B4F36;
            margin-bottom: 10px;
            display: block;
            text-align: left;
        }

        /* Suggestions */
        .suggestions {
            background: #E8F4F8;
            padding: 25px;
            padding-top: 3px;
            border-radius: 15px;
            margin: 40px 0;
            border-left: 5px solid #4ECDC4;
        }

        .suggestions h3 {
            color: #2C7873;
            margin-bottom: 15px;
            font-size: 22px;
        }

        .suggestions ul {
            margin: 0;
            padding-left: 20px;
        }

        .suggestions li {
            margin-bottom: 8px;
            line-height: 1.5;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .action-btn {
            font-family: 'Preahvihear', sans-serif;
            font-size: 16px;
            padding: 12px 25px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            border: none;
        }

        .action-btn.edit {
            background: #a8762f;
            color: white;
        }

        .action-btn.edit:hover {
            background: #845819;
        }

        .action-btn.delete {
            background: #c14633;
            color: white;
        }

        .action-btn.delete:hover {
            background: rgb(179, 50, 50);
        }

        .action-btn.back {
            background: #8e6b4c;
            color: white;
        }

        .action-btn.back:hover {
            background: #81532b;
        }

        /* Modal for delete confirmation */
        .modal {
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
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            max-width: 400px;
            width: 90%;
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }

        .modal-btn {
            padding: 10px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-weight: bold;
            border: none;
        }

        .modal-btn.confirm {
            background: #FF6B6B;
            color: white;
        }

        .modal-btn.cancel {
            background: #6B4F36;
            color: white;
        }
        
        /* Image modal for full view */
        .image-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.9);
            justify-content: center;
            align-items: center;
            z-index: 1001;
        }
        
        .image-modal-content {
            max-width: 90%;
            max-height: 90%;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(255,255,255,0.1);
        }
        
        .close-modal {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 40px;
            cursor: pointer;
            z-index: 1002;
        }
        
        .close-modal:hover {
            color: #D7923B;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .mood-details {
                flex-direction: column;
            }
            
            .image-section {
                flex: 0 0 auto;
            }
            
            .container {
                width: 95%;
            }
        }
    </style>
</head>

<body>

<div class="top-right">
    <a href="<%= request.getContextPath() %>/dashboard" class="home-link">
        <i class="fas fa-home"></i>
        SmileSpace 
    </a>
</div>

<div class="container">
    <h1>Daily Mood</h1>

    <div class="daily-header">
        <div class="daily-date">On <%= moodDate.format(displayFormat) %></div>
    </div>

    <div class="mood-details">
        <div class="mood-content">
            <div class="detail-row">
                <div class="detail-label">Mood:</div>
                <div class="detail-value"><%= dailyMood.getFeelingsAsString() %></div>
            </div>
            <% if (dailyMood.getReflection() != null && !dailyMood.getReflection().isEmpty()) { %>
            <div class="detail-row">
                <div class="detail-label">Reflection:</div>
                <div class="detail-value"><%= dailyMood.getReflection() %></div>
            </div>
            <% } %>
            <% if (dailyMood.getTags() != null && !dailyMood.getTags().isEmpty()) { %>
            <div class="detail-row">
                <div class="detail-label">Tags:</div>
                <div class="detail-value"><%= dailyMood.getTagsAsString() %></div>
            </div>
            <% } %>
        </div>
        
        <!-- Image Section -->
        <div class="image-section">
            <span class="image-label">Daily Snapshot:</span>
            <div class="image-container">
                <% if (hasImage) { 
                    // Make sure the path starts with "/" if it's a relative path
                    String fullImagePath = imagePath.startsWith("/") ? imagePath : "/" + imagePath;
                %>
                    <img src="<%= request.getContextPath() %><%= fullImagePath %>" 
                         alt="Mood snapshot" 
                         class="image-preview"
                         onclick="showFullImage(this.src)">
                    <div style="font-size: 12px; color: #8B7355; margin-top: 10px;">
                        <i class="fas fa-image"></i> Click image to view full size
                    </div>
                <% } else { %>
                    <div class="no-image">
                        <i class="fas fa-image"></i>
                        <div>No image uploaded</div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Suggestions -->
    <div class="suggestions">
        <h3>💡 Suggestions for This Day</h3>
        <ul id="dailySuggestions">
            <%
                // Generate suggestions based on mood and tags
                Set<String> feelings = new HashSet<>(dailyMood.getFeelings());
                Set<String> tags = dailyMood.getTags();
                
                if (feelings.contains("stressed") || feelings.contains("anxious") || 
                    tags.contains("exam_stress") || tags.contains("overwhelmed")) {
            %>
            <li>Take a 15-minute break to stretch and breathe</li>
            <li>Break your project into smaller, manageable tasks</li>
            <li>Communicate with your group about the workload</li>
            <li>Set a reasonable bedtime to avoid burnout</li>
            <% } else if (feelings.contains("happy") || feelings.contains("excited")) { %>
            <li>Celebrate and acknowledge your positive feelings</li>
            <li>Share your happiness with friends or loved ones</li>
            <li>Use this positive energy for creative activities</li>
            <li>Practice gratitude for the good moments</li>
            <% } else if (feelings.contains("sad") || feelings.contains("lonely")) { %>
            <li>Reach out to someone you trust for support</li>
            <li>Engage in comforting activities you enjoy</li>
            <li>Practice self-compassion and understanding</li>
            <li>Consider light exercise or going for a walk</li>
            <% } else { %>
            <li>Practice mindfulness throughout the day</li>
            <li>Stay hydrated and take regular movement breaks</li>
            <li>Acknowledge and accept your current feelings</li>
            <li>Maintain a balanced routine</li>
            <% } %>
        </ul>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <button class="action-btn edit" onclick="editMood()">✏️ Edit</button>
        <button class="action-btn delete" onclick="showDeleteModal()">🗑️ Delete</button>
        <a href="<%= request.getContextPath() %>/mood?action=viewTrends" class="action-btn back"><i class="fas fa-arrow-left"></i> Back to Calendar</a>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal" id="deleteModal">
    <div class="modal-content">
        <h3>Delete Mood Entry</h3>
        <p>Are you sure you want to delete this mood entry? This action cannot be undone.</p>
        <div class="modal-buttons">
            <button class="modal-btn confirm" onclick="deleteMood()">Yes, Delete</button>
            <button class="modal-btn cancel" onclick="hideDeleteModal()">Cancel</button>
        </div>
    </div>
</div>

<!-- Full Image Modal -->
<div class="image-modal" id="imageModal">
    <span class="close-modal" onclick="hideFullImage()">&times;</span>
    <img class="image-modal-content" id="fullImage">
</div>

<script>
    function editMood() {
        // Redirect to edit page with mood ID
        window.location.href = '<%= request.getContextPath() %>/mood?action=edit&id=<%= dailyMood.getId() %>';
    }

    function showDeleteModal() {
        document.getElementById('deleteModal').style.display = 'flex';
    }

    function hideDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
    }

    function deleteMood() {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '<%= request.getContextPath() %>/mood';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'deleteMood';

        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = '<%= dailyMood.getId() %>';
        
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);

        hideDeleteModal();
        form.submit();
    }
    
    // Full image view functionality
    function showFullImage(src) {
        document.getElementById('fullImage').src = src;
        document.getElementById('imageModal').style.display = 'flex';
    }
    
    function hideFullImage() {
        document.getElementById('imageModal').style.display = 'none';
    }
    
    // Close image modal when clicking outside the image
    document.getElementById('imageModal').addEventListener('click', function(e) {
        if (e.target === this) {
            hideFullImage();
        }
    });

</script>

</body>
</html>