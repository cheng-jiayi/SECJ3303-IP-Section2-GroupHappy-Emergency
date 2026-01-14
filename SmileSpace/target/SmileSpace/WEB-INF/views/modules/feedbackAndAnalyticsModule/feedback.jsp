<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("error");
    
    // Get user info from session
    String userFullName = (String) session.getAttribute("userFullName");
    String userRole = (String) session.getAttribute("userRole");
    
    // Handle userId - could be String or Integer
    Object userIdObj = session.getAttribute("userId");
    Integer userId = null;
    
    if (userIdObj != null) {
        if (userIdObj instanceof Integer) {
            userId = (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            try {
                userId = Integer.parseInt((String) userIdObj);
            } catch (NumberFormatException e) {
                // Handle the error or leave as null
                userId = null;
            }
        }
    }
    
    // Check if user is logged in
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Share Your Feedback - SmileSpace</title>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            padding-bottom: 40px;
            min-height: 100vh;
        }

        /* Header */
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            background: #FBF6EA;
            border-bottom: 2px solid #F0D5B8;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            color: #F0A548;
            text-decoration: none;
        }

        .logo:hover {
            color: #D7923B;
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
            transition: all 0.3s ease;
        }
        
        .user-btn:hover {
            background: #C77D2F;
            transform: scale(1.05);
        }
        
        .dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            min-width: 220px;
            display: none;
            z-index: 1000;
            overflow: hidden;
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
            font-size: 16px;
        }
        
        .user-role {
            background: #D7923B;
            color: white;
            padding: 4px 12px;
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
            transition: background 0.2s;
        }
        
        .menu-item:hover { 
            background: #FFF8E8; 
            text-decoration: none;
        }
        
        .menu-item.logout { 
            color: #E74C3C; 
        }

        /* Title */
        .title-wrapper { 
            text-align: center; 
            margin-top: 35px; 
            margin-bottom: 30px; 
        }
        
        .title-wrapper h1 { 
            color: #F0A548; 
            font-size: 40px; 
            font-weight: 700; 
            margin-bottom: 10px;
        }
        
        .title-wrapper p { 
            margin-top: 10px; 
            font-size: 18px; 
            color: #A06A2F; 
        }

        /* Feedback card */
        .feedback-card {
            width: 60%;
            background: #FFFFFF;
            border-radius: 20px;
            border: 2px solid #F0D5B8;
            margin: 0 auto;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        label { 
            font-weight: 600; 
            display: block; 
            margin: 14px 0 6px; 
            color: #713C0B;
        }
        
        input, textarea, select {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            background: #F4F2FA;
            border: 2px solid #E2D5C1;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #D7923B;
            background: #FFFFFF;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.1);
        }
        
        textarea { 
            height: 150px; 
            resize: vertical; 
            min-height: 120px;
        }

        /* Star Rating Styles */
        .rating-container {
            margin: 20px 0;
        }
        
        .rating-title {
            font-weight: 600;
            margin-bottom: 10px;
            color: #713C0B;
            display: block;
        }
        
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 5px;
        }
        
        .star-rating input {
            display: none;
        }
        
        .star-rating label {
            font-size: 40px;
            color: #E2D5C1;
            cursor: pointer;
            transition: color 0.2s;
            margin: 0;
            padding: 0;
        }
        
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #FFD700;
        }
        
        .rating-labels {
            display: flex;
            justify-content: space-between;
            margin-top: 5px;
            font-size: 12px;
            color: #A06A2F;
        }
        
        .rating-info {
            font-size: 14px;
            color: #8B7355;
            margin-top: 10px;
            padding: 10px;
            background: #FFF9F0;
            border-radius: 8px;
            border-left: 3px solid #F0A548;
        }
        
        .rating-info i {
            color: #F0A548;
            margin-right: 5px;
        }

        .submit-btn {
            width: 100%;
            margin-top: 22px;
            padding: 14px;
            border-radius: 12px;
            background: #BDF5C6;
            border: none;
            font-size: 17px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.25s;
            color: #2C6B2F;
        }
        
        .submit-btn:hover { 
            background: #A0EFB4; 
            transform: translateY(-2px); 
        }

        .helper-box {
            width: 60%;
            background: #FFF9F0;
            border-radius: 16px;
            margin: 30px auto;
            padding: 22px;
            border: 2px solid #F0D5B8;
        }

        ul { 
            margin-left: 20px; 
            margin-top: 10px; 
        }
        
        ul li { 
            margin-bottom: 8px; 
        }

        .error { 
            color: #E74C3C; 
            margin-top: 10px; 
            font-size: 14px; 
            padding: 10px;
            background: #FDEDED;
            border-radius: 8px;
            border-left: 4px solid #E74C3C;
        }

        /* Toast style */
        .toast {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #D4EDDA;
            color: #155724;
            border: 1px solid #C3E6CB;
            border-radius: 12px;
            padding: 18px 22px;
            min-width: 300px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        .toast strong { 
            display: block; 
            font-size: 16px; 
        }
        
        .toast p { 
            margin: 4px 0 0 0; 
            font-weight: 400; 
            font-size: 14px; 
        }
        
        .toast .close-btn { 
            background: transparent; 
            border: none; 
            font-size: 20px; 
            font-weight: bold; 
            cursor: pointer; 
            color: #155724;
            padding: 0 0 0 15px;
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .feedback-card, .helper-box {
                width: 80%;
            }
        }

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
            }
            
            .feedback-card, .helper-box {
                width: 90%;
                padding: 20px;
            }
            
            .title-wrapper h1 {
                font-size: 32px;
            }
            
            .title-wrapper p {
                font-size: 16px;
            }
            
            .star-rating label {
                font-size: 32px;
            }
        }
    </style>
</head>
<body>

    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="logo">SmileSpace</a>
        <div class="user-menu">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user"></i>
            </button>
            <div class="dropdown" id="dropdown">
                <div class="user-info">
                    <div class="user-name"><%= userFullName != null ? userFullName : "Guest" %></div>
                    <div class="user-role"><%= userRole != null ? userRole.substring(0,1).toUpperCase() + userRole.substring(1) : "Student" %></div>
                </div>
                <a href="${pageContext.request.contextPath}/profiles/studentProfile.jsp" class="menu-item">
                    <i class="fas fa-user-edit"></i> My Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Title -->
    <div class="title-wrapper">
        <h1>Share Your Feedback</h1>
        <p>Your thoughts help us improve the platform for all students.</p>
    </div>

    <!-- Feedback Form -->
    <div class="feedback-card">
        <% if (successMessage != null) { %>
            <div class="toast" id="successToast">
                <div>
                    <strong>Success!</strong>
                    <p><%= successMessage %></p>
                </div>
                <button class="close-btn" onclick="closeToast()">×</button>
            </div>
        <% } %>

        <% if (errorMessage != null) { %>
            <div class="error" id="errorMessage">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <% } %>

        <form id="feedbackForm" action="${pageContext.request.contextPath}/feedback/submit" method="POST">
            <label>Name (Optional)</label>
            <input type="text" name="name" placeholder="Your name" value="<%= userFullName != null ? userFullName : "" %>">
            
            <label>Email (Optional)</label>
            <%
                String userEmail = (String) session.getAttribute("userEmail");
            %>
            <input type="email" name="email" placeholder="your.email@university.edu" value="<%= userEmail != null ? userEmail : "" %>">
            
            <!-- Star Rating System -->
            <div class="rating-container">
                <span class="rating-title">Rate Your Experience *</span>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" required>
                    <label for="star5" title="5 stars">★</label>
                    
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4" title="4 stars">★</label>
                    
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3" title="3 stars">★</label>
                    
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2" title="2 stars">★</label>
                    
                    <input type="radio" id="star1" name="rating" value="1">
                    <label for="star1" title="1 star">★</label>
                </div>
            </div>
            
            <label>Category</label>
            <select name="category">
                <option value="General">General Feedback</option>
                <option value="User Experience">User Experience</option>
                <option value="Features">Features</option>
                <option value="Technical Issues">Technical Issues</option>
                <option value="Suggestions">Suggestions</option>
                <option value="Other">Other</option>
            </select>
            
            <label>Your Feedback *</label>
            <textarea name="message" placeholder="Tell us your thoughts, suggestions, or issues..." required></textarea>

            <button type="submit" class="submit-btn">
                <i class="fas fa-paper-plane"></i> Submit Feedback
            </button>
        </form>
    </div>

    <!-- Helper Suggestions -->
    <div class="helper-box">
        <strong>What kind of feedback is helpful?</strong>
        <ul>
            <li>Your experience using SmileSpace features</li>
            <li>Suggestions for new enhancements</li>
            <li>Bugs or technical issues you found</li>
            <li>How the platform could support students better</li>
            <li>Ideas to improve user experience</li>
        </ul>
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

        // Toast close
        function closeToast() {
            const toast = document.getElementById('successToast');
            if (toast) {
                toast.style.animation = 'slideIn 0.3s ease-out reverse';
                setTimeout(() => {
                    toast.style.display = 'none';
                }, 300);
            }
        }

        // Auto-hide toast after 5 seconds
        setTimeout(() => { 
            closeToast(); 
        }, 5000);

        // Form validation
        const form = document.getElementById("feedbackForm");
        form.addEventListener('submit', function(e) {
            const message = document.querySelector('textarea[name="message"]');
            const rating = document.querySelector('input[name="rating"]:checked');
            
            if (!rating) {
                e.preventDefault();
                alert('Please select a rating for your experience');
                return;
            }
            
            if (message.value.trim().length < 10) {
                e.preventDefault();
                alert('Please provide more detailed feedback (at least 10 characters)');
                message.focus();
            }
        });

        // Character counter
        const textarea = document.querySelector('textarea[name="message"]');
        const charCounter = document.createElement('div');
        charCounter.style.cssText = 'text-align: right; font-size: 12px; color: #666; margin-top: 5px;';
        textarea.parentNode.insertBefore(charCounter, textarea.nextSibling);
        
        function updateCharCounter() {
            const length = textarea.value.length;
            charCounter.textContent = `${length} characters (minimum 10)`;
            charCounter.style.color = length < 10 ? '#E74C3C' : '#27AE60';
        }
        
        textarea.addEventListener('input', updateCharCounter);
        updateCharCounter(); // Initial call
        
        // Star rating hover effect
        const stars = document.querySelectorAll('.star-rating label');
        const starInputs = document.querySelectorAll('.star-rating input');
        
        stars.forEach(star => {
            star.addEventListener('mouseover', function() {
                const value = this.getAttribute('for').replace('star', '');
                highlightStars(value);
            });
            
            star.addEventListener('mouseout', function() {
                const checkedInput = document.querySelector('.star-rating input:checked');
                if (checkedInput) {
                    highlightStars(checkedInput.value);
                } else {
                    resetStars();
                }
            });
        });
        
        starInputs.forEach(input => {
            input.addEventListener('change', function() {
                highlightStars(this.value);
            });
        });
        
        function highlightStars(value) {
            stars.forEach(star => {
                const starValue = star.getAttribute('for').replace('star', '');
                if (starValue <= value) {
                    star.style.color = '#FFD700';
                } else {
                    star.style.color = '#E2D5C1';
                }
            });
        }
        
        function resetStars() {
            stars.forEach(star => {
                star.style.color = '#E2D5C1';
            });
        }
        
        // Show sentiment based on selected rating
        starInputs.forEach(input => {
            input.addEventListener('change', function() {
                const rating = parseInt(this.value);
                let sentiment = '';
                let color = '';
                
                if (rating <= 2) {
                    sentiment = 'Negative';
                    color = '#E74C3C';
                } else if (rating === 3) {
                    sentiment = 'Neutral';
                    color = '#F39C12';
                } else {
                    sentiment = 'Positive';
                    color = '#2ECC71';
                }
                
                // Update rating info
                const ratingInfo = document.querySelector('.rating-info');
                ratingInfo.innerHTML = `<i class="fas fa-info-circle"></i> Rating: ${rating} stars = <strong style="color:${color}">${sentiment}</strong> feedback`;
            });
        });
    </script>

</body>
</html>