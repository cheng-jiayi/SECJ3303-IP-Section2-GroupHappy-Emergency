<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in and is a student
    String userRole = (String) session.getAttribute("userRole");
    String userFullName = (String) session.getAttribute("userFullName");
    
    if (userRole == null || !"student".equals(userRole)) {
        response.sendRedirect("../../loginPage.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Quiz Modules - SmileSpace</title>
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
        .container {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .welcome {
            margin-bottom: 40px;
            text-align: center;
        }
        .welcome h2 {
            color: #D7923B;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
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
            border: 2px solid #E8D4B9;
            min-height: 300px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
        }
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
            border-color: #D7923B;
        }
        .card img {
            width: 120px;
            height: 120px;
            object-fit: contain;
            margin-bottom: 20px;
            border-radius: 15px;
        }
        .card-title {
            color: #CF8224;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .card-desc {
            color: #8B7355;
            font-size: 14px;
            line-height: 1.5;
        }
        .back-btn {
            position: absolute;
            top: 25px;
            left: 40px;
            background: #D7923B;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s;
        }
        .back-btn:hover {
            background: #c77d2f;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            color: #6B4F36;
            font-weight: bold;
        }
        .user-badge {
            background: #D7923B;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <a href="<%= request.getContextPath() %>/studentDashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        <div class="logo">
            <h1>SmileSpace Quiz Modules</h1>
        </div>
        <div class="user-info">
            <span><%= userFullName %></span>
            <div class="user-badge">Student</div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="welcome">
            <h2>Welcome, <%= userFullName %>!</h2>
            <p>Choose a mental wellness module to explore</p>
        </div>

        <div class="card-container">
            <!-- Stress Module -->
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Stress'">
                <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture2.png" 
                     alt="Stress Management" 
                     onerror="this.src='https://cdn-icons-png.flaticon.com/512/3523/3523090.png'">
                <div class="card-title">Stress Management</div>
                <div class="card-desc">Learn techniques to manage and reduce stress in your daily life</div>
            </div>

            <!-- Anxiety Module -->
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Anxiety'">
                <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture3.png" 
                     alt="Anxiety Management"
                     onerror="this.src='https://cdn-icons-png.flaticon.com/512/3523/3523069.png'">
                <div class="card-title">Anxiety Management</div>
                <div class="card-desc">Tools and strategies to cope with anxiety and worry</div>
            </div>

            <!-- Sleep Module -->
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Sleep'">
                <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture4.png" 
                     alt="Sleep Management"
                     onerror="this.src='https://cdn-icons-png.flaticon.com/512/3523/3523048.png'">
                <div class="card-title">Sleep Management</div>
                <div class="card-desc">Improve your sleep quality and establish healthy routines</div>
            </div>

            <!-- Self-Esteem Module -->
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Self-Esteem'">
                <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture5.png" 
                     alt="Self-Esteem Building"
                     onerror="this.src='https://cdn-icons-png.flaticon.com/512/3523/3523056.png'">
                <div class="card-title">Self-Esteem Building</div>
                <div class="card-desc">Build confidence and develop positive self-image</div>
            </div>

            <!-- Mindfulness Module -->
            <div class="card" onclick="window.location.href='<%= request.getContextPath() %>/quiz-dashboard?category=Mindfulness'">
                <img src="<%= request.getContextPath() %>/modules/completeQuiz/images/Picture6.png" 
                     alt="Mindfulness Practice"
                     onerror="this.src='https://cdn-icons-png.flaticon.com/512/3523/3523105.png'">
                <div class="card-title">Mindfulness Practice</div>
                <div class="card-desc">Learn meditation and mindfulness techniques for mental clarity</div>
            </div>
        </div>
    </div>

    <script>
        // Debug: Log image paths
        console.log("Context Path: <%= request.getContextPath() %>");
        
        // Test all image paths
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                console.log("Image source:", img.src);
                
                // Add loading error handling
                img.onerror = function() {
                    console.error("Failed to load image:", this.src);
                    this.style.border = "2px dashed red";
                    this.nextElementSibling.innerHTML += " (Image not available)";
                };
                
                // Log when image loads successfully
                img.onload = function() {
                    console.log("Successfully loaded:", this.src);
                };
            });
        });

        // Add click animation to cards
        document.querySelectorAll('.card').forEach(card => {
            card.addEventListener('click', function() {
                this.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    this.style.transform = '';
                }, 200);
            });
        });
    </script>
</body>
</html>