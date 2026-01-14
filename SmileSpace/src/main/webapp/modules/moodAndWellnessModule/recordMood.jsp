<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Track My Mood</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body {
            background-color: #FFF8E8;
            font-family: 'Preahvihear', sans-serif;
            color: #6B4F36;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            width: 80%;
            text-align: left;
            margin-top: 100px;
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
            font-size: 36px;
            font-weight: 600;
            text-align: left;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .subtitle {
            font-size: 20px;
            margin-bottom: 35px;
            text-align: left;
            font-weight: 400;
            color: #CF8224;
        }

        .message {
            font-size: 25px;
            margin-top: 20px;
            margin-bottom: 35px;
            text-align: left;
            font-weight: 630;
        }

        .reminder {
            margin-bottom: 45px;
            text-align: left;
        }

        .reminder-title {
            font-size: 18px;
            font-weight: 500;
            color: #D1872C;
        }

        .reminder-message {
            font-size: 28px;
            font-weight: 630;
            color: #B87727;
        }

        .card-container {
            display: flex;
            justify-content: flex-start;
            gap: 40px;
            margin-top: 30px;
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
    <a href="<%= request.getContextPath() %>/modules/userManagementModule/dashboards/studentDashboard.jsp" class="home-link">
        <i class="fas fa-home"></i>
        SmileSpace 
    </a>
</div>

<div class="container">

    <h1>Track My Mood</h1>

    <%
        String lastMood = (String) request.getAttribute("lastMood");
        String lastDate = (String) request.getAttribute("lastDate");

        if (lastMood == null) lastMood = "Happy and Relaxed";
        if (lastDate == null) lastDate = "6 Nov 2025";
    %>

    <div class="subtitle">
        Last recorded mood: <b><%= lastMood %></b> on <%= lastDate %>
    </div>

    <div class="message">Your feelings are valid. Allow yourself to feel them.</div>

    <div class="reminder">
        <div class="reminder-title">Today's Reminder</div>
        <div class="reminder-message">Be kind to yourself — you're doing your best.</div>
    </div>

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