<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.MoodEntry" %>
<%
    // Get previously selected feelings from servlet attribute
    String[] selectedFeelings = (String[]) request.getAttribute("selectedFeelings");
    if (selectedFeelings == null) {
        // If no attribute, check parameters (for backward compatibility)
        selectedFeelings = request.getParameterValues("feelings");
    }
    
    // Check if we're in edit mode
    MoodEntry moodToEdit = (MoodEntry) request.getAttribute("moodToEdit");
    boolean isEdit = moodToEdit != null;
    String moodId = "";
    if (isEdit) {
        moodId = String.valueOf(moodToEdit.getId());
    }
    
    // Get referrer parameter to know where to go back
    String referrer = request.getParameter("referrer");
    if (referrer == null) {
        referrer = "recordMood"; // default to recordMood
    }
    
    // Get the original referring page from session
    String backUrl = (String) session.getAttribute("moodOriginalReferer");
    
    // If no session referer, try to construct from parameters
    if (backUrl == null || backUrl.isEmpty()) {
        // If we're in edit mode and have a mood entry, go back to that date's daily view
        if (moodToEdit != null) {
            backUrl = request.getContextPath() + "/mood?action=viewDaily&date=" + moodToEdit.getEntryDate();
        } 
        // Fallback based on referrer parameter
        else if ("trends".equals(referrer)) {
            backUrl = request.getContextPath() + "/mood?action=viewTrends";
        } else {
            backUrl = request.getContextPath() + "/mood"; // default to recordMood
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>How are you feeling?</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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
            text-align: center;
            margin-top: 10%;
        }
        
        h1 {
            color: #6B4F36;
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        /* Feelings Grid */
        .feelings-grid {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .feeling-option {
            text-align: center;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .feeling-option input {
            display: none;
        }

        .feeling-option img {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            transition: 0.3s;
            border: 3px solid transparent;
        }

        .feeling-option:hover img {
            transform: scale(1.1);
            border: 3px solid #D7923B;
        }

        .feeling-option.checked img {
            transform: scale(1.15);
            border: 4px solid #D7923B;
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3);
        }

        .feeling-option div {
            margin-top: 0;
            font-weight: 600;
            font-size: 16px;
        }

        /* Navigation Buttons */
        .nav-buttons {
            margin-top: 60px;
            margin-bottom: 60px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .next-btn {
            background: #935305;
            font-family: 'Preahvihear', sans-serif;
            border: none;
            padding: 15px 40px;
            font-size: 15px;
            border-radius: 40px;
            color: #fff;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.2s;
        }

        .next-btn:hover {
            background: #c77d2f;
        }

        .next-btn:disabled {
            background: #cccccc;
            cursor: not-allowed;
        }

        .back-link {
            font-size: 15px;
            display: inline-block;
            padding: 15px 30px;
            color: #6B4F36;
            text-decoration: none;
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
    <h1><%= isEdit ? "Edit Your Mood Feelings" : "How are you feeling today?" %></h1>
    <p style="font-size: 18px; color: #8B7355; margin-bottom: 50px;">Select one or more feelings that describe your mood.</p>

    <form id="feelingsForm" action="<%= request.getContextPath() %>/mood" method="post">
        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "addMoodDetails" %>">
        <!-- Pass referrer as hidden field -->
        <input type="hidden" name="referrer" value="<%= referrer %>">
        <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= moodId %>">
        <% } %>
        
        <div class="feelings-grid">
            <%
                String[] feelingsList = {"neutral", "excited", "warm", "anxious", "stressed", "relaxed", "happy", "sad", "playful"};
                for(String feeling : feelingsList) {
                    boolean isChecked = false;
                    if (selectedFeelings != null) {
                        for(String selected : selectedFeelings) {
                            if (feeling.equalsIgnoreCase(selected)) {
                                isChecked = true;
                                break;
                            }
                        }
                    }
                    
                    // Apply inline styles for checked state
                    String imgStyle = "";
                    if (isChecked) {
                        imgStyle = "style='transform: scale(1.15); border: 4px solid #D7923B; box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3);'";
                    }

                    String displayName = feeling.substring(0, 1).toUpperCase() + feeling.substring(1);
            %>
            <label class="feeling-option <%= isChecked ? "checked" : "" %>" data-feeling="<%= feeling %>">
                <input type="checkbox" name="feelings" value="<%= feeling %>" <%= isChecked ? "checked" : "" %>>
                <img src="<%= request.getContextPath() %>/modules/moodAndWellnessModule/images/feelings/<%= feeling %>.png" alt="<%= displayName %>" <%= imgStyle %>>
                <div><%= displayName %></div>
            </label>
            <% } %>
        </div>

        <div class="nav-buttons">
            <a href="<%= backUrl %>" class="back-link"><i class="fas fa-arrow-left"></i> Back</a>
            <button type="submit" class="next-btn" id="nextBtn">Next <i class="fas fa-arrow-right"></i></button>
        </div>
    </form>
</div>

<script>
    // Enable next button only when at least one feeling is selected
    const checkboxes = document.querySelectorAll('input[name="feelings"]');
    const nextBtn = document.getElementById('nextBtn');
    const feelingOptions = document.querySelectorAll('.feeling-option');
    
    function updateNextButton() {
        const atLeastOneChecked = Array.from(checkboxes).some(cb => cb.checked);
        nextBtn.disabled = !atLeastOneChecked;
    }
    
    // Add click event to each feeling option
    feelingOptions.forEach(option => {
        option.addEventListener('click', function() {
            const checkbox = this.querySelector('input[type="checkbox"]');
            const img = this.querySelector('img');
            checkbox.checked = !checkbox.checked;
            
            if (checkbox.checked) {
                this.classList.add('checked');
                img.style.transform = 'scale(1.15)';
                img.style.border = '4px solid #D7923B';
                img.style.boxShadow = '0 4px 12px rgba(215, 146, 59, 0.3)';
            } else {
                this.classList.remove('checked');
                img.style.transform = 'scale(1)';
                img.style.border = '3px solid transparent';
                img.style.boxShadow = 'none';
            }
            
            updateNextButton();
        });
    });
    
    // Initialize button state
    updateNextButton();
</script>

</body>
</html>