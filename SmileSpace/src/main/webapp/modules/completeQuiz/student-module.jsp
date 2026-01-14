<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Learning Module Dashboard - SmileSpace</title>
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

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #F0A548;
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: flex-end; 
            margin-left: auto;    
        }
        
        .logo i {
            color: #F0A548;
            font-size: 22px;
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

        .card-container {
            display: flex;
            justify-content: flex-start;
            gap: 40px;
            margin-top: 30px;
            flex-wrap: wrap;
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
    <div class="logo">
        <i class="fas fa-home"></i>
        SmileSpace
    </div>
</a>
</div>

<div class="container">

    <h1>Learning Module Dashboard</h1>

    <div class="subtitle">
        There are different categories of learning modules available. 
    </div>

    <div class="card-container">
        <!-- Stress Module -->
        <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Stress'">
            <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture2.png" alt="Stress Module">
            <div class="card-title">Stress Management</div>
        </div>

        <!-- Anxiety Module -->
        <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Anxiety'">
            <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture3.png" alt="Anxiety Module">
            <div class="card-title">Anxiety Management</div>
        </div>

        <!-- Sleep Module -->
        <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Sleep'">
            <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture4.png" alt="Sleep Module">
            <div class="card-title">Sleep Management</div>
        </div>

        <!-- Self-Esteem Module -->
        <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Self-Esteem'">
            <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture5.png" alt="Self-Esteem Module">
            <div class="card-title">Self-Esteem Building</div>
        </div>

        <!-- Mindfulness Module -->
        <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Mindfulness'">
            <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture6.png" alt="Mindfulness Module">
            <div class="card-title">Mindfulness Practice</div>
        </div>
    </div>
</div>

</body>
</html>