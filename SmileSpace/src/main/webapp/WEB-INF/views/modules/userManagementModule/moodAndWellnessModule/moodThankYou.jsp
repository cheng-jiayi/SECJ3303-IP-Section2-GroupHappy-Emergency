<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.MoodEntry" %>
<%
    // Get the saved mood entry from request attribute
    MoodEntry savedEntry = (MoodEntry) request.getAttribute("savedEntry");
    if (savedEntry == null) {
        // If no saved entry, redirect to main page
        response.sendRedirect(request.getContextPath() + "/mood");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thank You</title>
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
            margin-bottom: 0;
        }

        .thank-you-message {
            font-size: 17px;
            color: #8B7355;
            margin-bottom: 30px;
        }

        .mood-details {
            font-size: 16px;
            background: #FFF3C8;
            padding: 20px;
            padding-bottom: 20px;
            border-radius: 15px;
            margin: 15px 0;
        }

        .detail-row {
            /* margin-bottom: 15px; */
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

        .suggestions {
            background: #E8F4F8;
            padding: 20px;
            border-radius: 15px;
            margin: 30px 0;
            border-left: 5px solid #4ECDC4;
        }

        .suggestions h3 {
            color: #2C7873;
            margin-bottom: 15px;
            margin-top: 0;
            padding-top: 0;
            font-size: 19px;
        }

        .suggestions ul {
            font-size: 15px;
            margin: 0;
            padding-left: 20px;
        }

        .suggestions li {
            margin-bottom: 8px;
            line-height: 1.5;
        }

        .card-container {
            display: flex;
            justify-content: flex-start;
            gap: 40px;
            margin-top: 40px;
            margin-bottom: 60px;
        }

        .card {
            background-color: #FFF3C8;
            width: 260px;
            padding: 5px;
            border-radius: 12px;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: 0.2s;
            text-align: center;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card img {
            height: 130px !important;
            display: block !important;
            visibility: visible !important;
            margin: 0 auto !important;
        }
        
        .card-title {
            font-size: 18px;
            font-weight: 600;
            text-align: center;
            color: #CF8224;
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
    <h1>Thank You! 💫</h1>
    <div class="thank-you-message">
        Thank you for taking time to reflect on your day.
    </div>

    <!-- Mood Details -->
    <div class="mood-details">
        <div class="detail-row">
            <div class="detail-label">Date:</div>
            <div class="detail-value"><%= savedEntry.getFormattedDate() %></div>
        </div>
        <div class="detail-row">
            <div class="detail-label">Mood:</div>
            <div class="detail-value"><%= savedEntry.getFeelingsAsString() %></div>
        </div>
        <% if (savedEntry.getReflection() != null && !savedEntry.getReflection().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label">Reflection:</div>
            <div class="detail-value"><%= savedEntry.getReflection() %></div>
        </div>
        <% } %>
        <% if (savedEntry.getTags() != null && !savedEntry.getTags().isEmpty()) { %>
        <div class="detail-row">
            <div class="detail-label">Tags:</div>
            <div class="detail-value"><%= savedEntry.getTagsAsString() %></div>
        </div>
        <% } %>
    </div>

    <!-- Suggestions -->
    <div class="suggestions">
        <h3>💡 Suggestions for You</h3>
        <ul>
            <%
                // Simple suggestions based on feelings
                java.util.Set<String> feelingsSet = new java.util.HashSet<>(savedEntry.getFeelings());
                java.util.Set<String> tagsSet = savedEntry.getTags();
                
                if (feelingsSet.contains("stressed") || feelingsSet.contains("anxious") || 
                    tagsSet.contains("exam_stress") || tagsSet.contains("overwhelmed")) {
            %>
            <li>Take a 5-minute breathing break</li>
            <li>Break tasks into smaller steps</li>
            <li>Try the Pomodoro technique (25min work, 5min break)</li>
            <% } else if (feelingsSet.contains("sad") || feelingsSet.contains("lonely")) { %>
            <li>Reach out to a friend or family member</li>
            <li>Listen to uplifting music</li>
            <li>Spend time in nature if possible</li>
            <% } else if (feelingsSet.contains("happy") || feelingsSet.contains("excited")) { %>
            <li>Celebrate your positive moments!</li>
            <li>Share your happiness with others</li>
            <li>Use this energy for creative projects</li>
            <% } else { %>
            <li>Practice mindfulness throughout the day</li>
            <li>Stay hydrated and take movement breaks</li>
            <li>Acknowledge and accept your feelings</li>
            <% } %>
        </ul>
    </div>

    <!-- Action Buttons -->
    <div class="card-container">
       <div class="card" onclick="location.href='<%= request.getContextPath() %>/mood?action=viewTrends'">
            <img src="<%= request.getContextPath() %>/modules/moodAndWellnessModule/images/cat_book.png" alt="View Trends">
            <div class="card-title">View My Mood Trends</div>
        </div>

        <div class="card" onclick="location.href='<%= request.getContextPath() %>/mood?action=add'">
            <img src="<%= request.getContextPath() %>/modules/moodAndWellnessModule/images/cat_laptop.png" alt="Add Mood">
            <div class="card-title">Add My Mood</div>
        </div>
    </div>
</div>

</body>
</html>