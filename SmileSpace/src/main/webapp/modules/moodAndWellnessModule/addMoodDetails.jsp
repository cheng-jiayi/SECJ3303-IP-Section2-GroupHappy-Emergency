<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.MoodEntry" %>
<%@ page import="java.util.*" %>
<%
    // Get selected feelings from servlet attribute (preferred) or parameters
    String[] selectedFeelings = (String[]) request.getAttribute("selectedFeelings");
    if (selectedFeelings == null) {
        selectedFeelings = request.getParameterValues("feelings");
    }
    if (selectedFeelings == null) {
        // Redirect back if no feelings selected
        response.sendRedirect(request.getContextPath() + "/mood?action=add");
        return;
    }
    
    // Get mood entry for editing
    MoodEntry moodToEdit = (MoodEntry) request.getAttribute("moodToEdit");
    boolean isEdit = moodToEdit != null;
    
    // Pre-populate data for editing
    String reflection = "";
    Set<String> existingTags = new HashSet<>();
    
    if (isEdit) {
        reflection = moodToEdit.getReflection() != null ? moodToEdit.getReflection() : "";
        if (moodToEdit.getTags() != null) {
            existingTags = moodToEdit.getTags();
        }
    }
    
    // Build back URL with selected feelings
    StringBuilder backUrl = new StringBuilder(request.getContextPath() + "/mood?action=add");
    for(String feeling : selectedFeelings) {
        backUrl.append("&feelings=").append(java.net.URLEncoder.encode(feeling, "UTF-8"));
    }
    
    // If editing, add the mood ID to back URL
    if (isEdit) {
        backUrl.append("&id=").append(moodToEdit.getId());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Edit Mood Entry" : "Add Mood Details" %></title>
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

        h1 {
            color: #6B4F36;
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 0;
        }

        h2 {
            color: #946a45;
            font-size: 23px;
            font-weight: 600;
        }

        h3 {
            color: #6B4F36;
            font-size: 15px;
            font-weight: 600;
            margin-top: 30px;
        }

        .selected-feelings {
            background: #FFF3C8;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            font-weight: 500;
        }

        /* Form Elements */
        textarea, input[type="text"] {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #D4A46D;
            resize: none;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            margin-bottom: 10px;
        }

        textarea {
            height: 100px;
        }

        /* Tags Section */
        .tags-section {
            display: flex;
            flex-wrap: wrap;
            margin: 0;
        }

        .tag-column {
            flex: 1;
            min-width: 200px;
            margin-bottom: 20px;
        }

        .tag-column h4 {
            color: #936236;
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 0;
            margin-top: 0;
            padding-top: 0;
        }

        .tag-option {
            display: block;
            font-size: 14px;
            font-weight: 400;
        }

        .tag-option input {
            margin-right: 4px;
        }

        /* Upload Section */
        .upload-box {
            margin-top: 10px;
            border: 2px dashed #D4A46D;
            padding: 30px;
            text-align: center;
            border-radius: 15px;
            background: #FFF3C8;
            font-family: 'Preahvihear', sans-serif; 
        }

        .custom-file-upload {
            font-family: 'Preahvihear', sans-serif;
            background: #D7923B;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            cursor: pointer;
            display: inline-block;
            transition: background 0.2s;
        }

        .custom-file-upload:hover {
            background: #c77d2f;
        }

        /* Buttons */
        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 40px;
            margin-bottom: 60px;
        }

        .submit-btn {
            font-family: 'Preahvihear', sans-serif;
            background: #D7923B;
            border: none;
            padding: 15px 25px;
            font-size: 15px;
            border-radius: 40px;
            color: #fff;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.2s;
        }

        .submit-btn:hover {
            background: #c77d2f;
        }

        .back-link {
            display: inline-block;
            padding: 15px 25px;
            color: #6B4F36;
            text-decoration: none;
            font-size: 15px;
            font-weight: bold;
            border: 2px solid #6B4F36;
            border-radius: 40px;
            transition: all 0.2s;
        }

        .back-link:hover {
            background: #6B4F36;
            color: white;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="container">
    <h1><%= isEdit ? "Edit Your Mood Entry" : "How are you feeling today?" %></h1>
    <h2><%= isEdit ? "Update your mood details" : "Would you like to add more details?" %></h2>

    <div class="selected-feelings">
        <strong>Selected feelings:</strong> 
        <%= String.join(", ", selectedFeelings) %>
    </div>

    <form action="<%= request.getContextPath() %>/mood" method="post" enctype="multipart/form-data">
        <% for(String feeling : selectedFeelings) { %>
            <input type="hidden" name="feelings" value="<%= feeling %>">
        <% } %>
        
        <input type="hidden" name="action" value="<%= isEdit ? "updateMood" : "addMood" %>">
        <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= moodToEdit.getId() %>">
        <% } %>

        <h3>What made you feel like this today? (Optional)</h3>
        <textarea name="reflection" placeholder="Share what's on your mind..."><%= reflection %></textarea>

        <h3>Add tags to describe your day:</h3>
        <div class="tags-section">
            <div class="tag-column">
                <h4>Academic / Work</h4>
                <%
                    String[] academicTags = {"exam_stress", "coursework", "presentation", "group_project", "assignment_due", "productive", "procrastination", "late_night_study"};
                    for(String tag : academicTags) {
                        boolean isChecked = existingTags.contains(tag);
                %>
                <label class="tag-option">
                    <input type="checkbox" name="tags" value="<%= tag %>" <%= isChecked ? "checked" : "" %>>
                    <span><%= tag.replace("_", " ").substring(0, 1).toUpperCase() + tag.replace("_", " ").substring(1) %></span>
                </label>
                <% } %>
            </div>

            <div class="tag-column">
                <h4>Social / Relationships</h4>
                <%
                    String[] socialTags = {"friends", "family", "conflict", "lonely", "supported", "grateful", "encouraged", "social_anxiety"};
                    for(String tag : socialTags) {
                        boolean isChecked = existingTags.contains(tag);
                %>
                <label class="tag-option">
                    <input type="checkbox" name="tags" value="<%= tag %>" <%= isChecked ? "checked" : "" %>>
                    <span><%= tag.replace("_", " ").substring(0, 1).toUpperCase() + tag.replace("_", " ").substring(1) %></span>
                </label>
                <% } %>
            </div>

            <div class="tag-column">
                <h4>Emotional / Personal Growth</h4>
                <%
                    String[] emotionalTags = {"motivated", "overwhelmed", "confident", "hopeful", "lost", "calm", "frustrated", "inspired"};
                    for(String tag : emotionalTags) {
                        boolean isChecked = existingTags.contains(tag);
                %>
                <label class="tag-option">
                    <input type="checkbox" name="tags" value="<%= tag %>" <%= isChecked ? "checked" : "" %>>
                    <span><%= tag.substring(0, 1).toUpperCase() + tag.substring(1) %></span>
                </label>
                <% } %>
            </div>

            <div class="tag-column">
                <h4>Daily Mood</h4>
                <%
                    String[] dailyTags = {"good_day", "bad_day", "morning_class", "weekend", "rainy_weather", "coffee_break", "alone_time", "fun_activity"};
                    for(String tag : dailyTags) {
                        boolean isChecked = existingTags.contains(tag);
                %>
                <label class="tag-option">
                    <input type="checkbox" name="tags" value="<%= tag %>" <%= isChecked ? "checked" : "" %>>
                    <span><%= tag.replace("_", " ").substring(0, 1).toUpperCase() + tag.replace("_", " ").substring(1) %></span>
                </label>
                <% } %>
            </div>
        </div>

        <!-- Optional Image Upload -->
        <h3>Share a glimpse of your day (Optional)</h3>
        <div class="upload-box">
            <label for="imageUpload" class="custom-file-upload">
                <i class="fas fa-cloud-upload-alt"></i> Choose Image
            </label>
            <input id="imageUpload" type="file" name="imagePath" accept="image/*" style="display: none;">
            <div id="fileName" style="margin-top: 10px; font-size: 14px; color: #6B4F36;"></div>
        </div>

        <div class="form-actions">
            <a href="<%= backUrl.toString() %>" class="back-link"><i class="fas fa-arrow-left"></i> Back to Feelings</a>
            <button type="submit" class="submit-btn">
                <%= isEdit ? "Update Mood Entry" : "Save Mood Entry" %>
            </button>
        </div>
    </form>
</div>

<script>
    // File upload display
    document.getElementById('imageUpload').addEventListener('change', function(e) {
        const fileName = e.target.files[0] ? e.target.files[0].name : 'No file chosen';
        document.getElementById('fileName').textContent = fileName;
    });
</script>

</body>
</html>