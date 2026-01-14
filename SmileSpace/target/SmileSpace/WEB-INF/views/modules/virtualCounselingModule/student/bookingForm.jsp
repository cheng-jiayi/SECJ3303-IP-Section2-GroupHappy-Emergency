<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Counseling Session - SmileSpace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #FFF8E8; 
            font-family: 'Inter', sans-serif; 
            color: #6B4F36; 
            margin: 0; 
            padding: 0; 
            display: flex; 
            justify-content: center; 
            align-items: flex-start; 
        }

        .container { 
            width: 90%; 
            max-width: 1200px; 
            text-align: left; 
            margin-top: 3%; 
        }

        .top-right { 
            position: absolute; 
            right: 40px; 
            top: 20px; 
            font-family: 'Preahvihear', sans-serif; 
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
            font-size: 40px; 
            font-weight: 600; 
            text-align: left; 
            margin-bottom: 10px; 
            padding-bottom: 0; 
            color: #6B4F36; 
            font-family: 'Preahvihear', sans-serif; 
        }

        .subtitle { 
            font-family: 'Preahvihear', sans-serif; 
            font-size: 18px; 
            margin-bottom: 20px; 
            text-align: left; 
            font-weight: 400; 
            color: #CF8224; 
        }

        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 30px; 
        }

        .back-btn { 
            font-family: 'Preahvihear', sans-serif; 
            background: #8B7355; 
            color: white; 
            padding: 12px 25px; 
            text-decoration: none; 
            border-radius: 25px; 
            font-size: 15px; 
            font-weight: 600; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            transition: all 0.3s; 
        }

        .back-btn:hover { 
            background: #6B4F36; 
            transform: translateY(-2px); 
            text-decoration: none; 
            color: white; 
        }

        .form-content { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 30px; 
            align-items: start; 
            margin-bottom: 60px; 
        }

        .card { 
            background: #FFF3C8; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1); 
            height: fit-content; 
        }

        .card h2 { 
            font-size: 22px; 
            color: #6B4F36; 
            margin-top: 0;
            margin-bottom: 25px; 
            padding-bottom: 10px; 
            border-bottom: 2px solid #E8D4B9; 
        }

        .form-group { 
            margin-bottom: 25px; 
            width: 100%; 
        }

        label { 
            display: block; 
            font-weight: 600; 
            margin-bottom: 10px; 
            color: #6B4F36; 
            font-size: 14px; 
        }

        label.required::after { 
            content: " *"; 
            color: #E74C3C; 
        }

        textarea, input { 
            width: 100%; 
            padding: 10px; 
            border: 2px solid #E8D4B9; 
            border-radius: 10px; 
            font-family: 'Inter', sans-serif; 
            font-size: 14px; 
            background: white; 
            color: #6B4F36; 
            transition: all 0.3s; 
            box-sizing: border-box; 
            display: block; 
        }

        select { 
            width: 100%; 
            padding: 10px; 
            border: 2px solid #E8D4B9; 
            border-radius: 10px; 
            font-family: 'Inter', sans-serif; 
            font-size: 14px; 
            background: white; 
            color: #6B4F36; 
            transition: all 0.3s; 
            box-sizing: border-box; 
            display: block; 
            appearance: none; 
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%236B4F36' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e"); 
            background-repeat: no-repeat; 
            background-position: right 8px center; 
            background-size: 16px; 
        }

        select:focus { 
            outline: none; 
            border-color: #D7923B; 
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.2); 
        }

        textarea:focus, input:focus { 
            outline: none; 
            border-color: #D7923B; 
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.2); 
        }

        textarea { 
            height: 120px; 
            resize: vertical; 
        }

        .calendar-container { 
            background: #fff6da; 
            padding: 20px; 
            border-radius: 12px; 
            border: 2px solid #E8D4B9; 
            margin-bottom: 20px; 
        }

        .calendar-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 5px; 
        }

        .calendar-header h3 { 
            margin: 0; 
            color: #6B4F36; 
            font-size: 14px; 
            font-weight: 600; 
        }

        .calendar-subtitle { 
            font-size: 13px; 
            color: #CF8224; 
            margin-bottom: 15px; 
            text-align: left; 
        }

        .calendar-nav { 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }

        .calendar-nav button { 
            background: #D7923B; 
            color: white; 
            border: none; 
            border-radius: 50%;
            width: 30px; 
            height: 30px; 
            cursor: pointer; 
            font-size: 13px; 
            transition: all 0.3s; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
        }

        .calendar-nav button:hover { 
            background: #C77D2F; 
            transform: scale(1.1); 
        }

        #currentMonth { 
            font-size: 14px; 
            font-weight: 600;
            color: #6B4F36; 
            min-width: 150px; 
            text-align: center; 
        }

        .calendar-grid { 
            display: grid; 
            grid-template-columns: repeat(7, 1fr); 
            gap: 5px; 
            font-size: 14px; 
            margin-bottom: 20px; 
        }

        .calendar-day { 
            padding: 8px 5px; 
            text-align: center; 
            border-radius: 8px; 
            cursor: pointer; 
            transition: all 0.3s; 
            font-size: 14px; 
            font-weight: 500; 
            min-height: 20px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
        }

        .calendar-day:hover { 
            background: #FFEBB5; 
            transform: translateY(-2px); 
        }

        .calendar-day.selected { 
            background: #D7923B; 
            color: white; 
            transform: translateY(-2px); 
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3); 
        }

        .calendar-day.other-month { 
            color: #A88C6D; 
            cursor: not-allowed; 
        }
        
        .calendar-day.disabled { 
            color: #D3C1A7; 
            cursor: not-allowed; 
            background: #F5F5F5; 
        }

        .time-slots { 
            display: grid; 
            grid-template-columns: repeat(2, 1fr); 
            gap: 10px; margin-top: 15px; 
        }

        .time-slot { 
            padding: 10px; 
            text-align: center; 
            border: 2px solid #E8D4B9; 
            border-radius: 10px; 
            cursor: pointer; 
            transition: all 0.3s; 
            font-size: 14px; 
            font-weight: 500; 
            background: white; 
        }

        .time-slot:hover { 
            background: #FFEBB5; 
            transform: translateY(-2px); 
        }

        .time-slot.selected { 
            background: #D7923B; 
            color: white; 
            border-color: #D7923B; 
            transform: translateY(-2px); 
            box-shadow: 0 4px 12px rgba(215, 146, 59, 0.3); 
        }

        .mood-multiselect { 
            position: relative; 

        }
        .mood-select-display { 
            border: 2px solid #E8D4B9; 
            border-radius: 10px; 
            padding: 10px; 
            cursor: pointer; 
            background: white;
            min-height: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            align-items: center;
            font-size: 14px;
        }
        .mood-options { 
            display: none; 
            position: absolute; 
            top: 100%; 
            left: 0; 
            right: 0; 
            background: white; 
            border: 2px solid #E8D4B9; 
            border-radius: 10px; 
            padding: 15px; 
            margin-top: 5px;
            max-height: 200px; 
            overflow-y: auto; 
            z-index: 1000;
            box-shadow: 0 4px 12px rgba(107, 79, 54, 0.1);
        }
        .mood-multiselect.open .mood-options { 
            display: block; 
        }
        .mood-option { 
            display: flex; 
            align-items: center; 
            padding: 8px; 
            cursor: pointer;
            border-radius: 6px;
        }
        .mood-option:hover { 
            background: #FFF8E8; 
        }
        .mood-option input { 
            width: auto; 
            margin-right: 10px; 
        }
        .mood-option label { 
            margin: 0; 
            cursor: pointer;
            font-weight: normal;
        }
        .mood-tag { 
            background: #D7923B; 
            color: white; 
            padding: 4px 10px; 
            border-radius: 15px; 
            font-size: 12px; 
            display: inline-flex; 
            align-items: center; 
            gap: 6px;
        }
        .mood-tag .remove { 
            cursor: pointer; 
            font-weight: bold; 
            font-size: 14px;
        }
        .mood-tag .remove:hover { 
            color: #FFF8E8; 
        }
        .placeholder-text { 
            color: #A88C6D; 
            font-style: italic;
        }
        .form-actions { 
            display: flex; 
            gap: 20px; 
            justify-content: flex-end; 
            margin-top: 35px; 
            margin-bottom: 35px; 
        }

        .submit-btn { 
            background: #D7923B; 
            color: white; 
            padding: 15px 35px; 
            border: none; 
            border-radius: 30px; 
            cursor: pointer; 
            font-weight: 600; 
            font-size: 15px; 
            font-family: 'Preahvihear', sans-serif; 
            transition: all 0.3s; 
        }

        .submit-btn:hover { 
            background: #C77D2F; 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(215, 146, 59, 0.4); 
        }

        .cancel-btn { 
            background: #8B7355; 
            color: white; 
            padding: 15px 35px; 
            border: none; 
            border-radius: 30px; 
            cursor: pointer; 
            text-decoration: none; 
            font-weight: 600; 
            font-size: 15px; 
            font-family: 'Preahvihear', sans-serif; 
            transition: all 0.3s; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
        }

        .cancel-btn:hover { 
            background: #6B4F36; 
            transform: translateY(-2px); 
            text-decoration: none; 
            color: white; 
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
    <div class="header">
        <div>
            <h1>Book a Counseling Session</h1>
            <div class="subtitle">Schedule your counseling session and share what's on your mind.</div>
        </div>
        <a href="counseling?action=viewSessions" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Sessions
        </a>
    </div>

    <form action="counseling" method="post" id="bookingForm">
        <input type="hidden" name="action" value="submitBooking">
        <input type="hidden" name="sessionDate" id="sessionDate">
        <input type="hidden" name="sessionTime" id="sessionTime">
        <input type="hidden" name="studentId" value="${sessionScope.userId}">

        <div class="form-content">
            <div class="card">
                <h2>Session Details</h2>
                <div class="form-group">
                    <label for="sessionType" class="required">Session Type</label>
                    <select id="sessionType" name="sessionType" required>
                        <option value="">Select session type</option>
                        <option value="In-Person">In-Person</option>
                        <option value="Video Call">Video Call</option>
                        <option value="Phone Call">Phone Call</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="required">Date & Time</label>
                    <div class="calendar-container">
                        <div class="calendar-header">
                            <h3>Select Date</h3>
                            <div class="calendar-nav">
                                <button type="button" id="prevMonth">&#8249;</button>
                                <div id="currentMonth"></div>
                                <button type="button" id="nextMonth">&#8250;</button>
                            </div>
                        </div>
                        <div class="calendar-subtitle">Choose a suitable date for your session.</div>
                        <div class="calendar-grid" id="calendarGrid"></div>

                        <div class="time-slots" id="timeSlots">
                            <div class="time-slot" data-time="09:00">09:00 AM</div>
                            <div class="time-slot" data-time="11:00">11:00 AM</div>
                            <div class="time-slot" data-time="14:00">02:00 PM</div>
                            <div class="time-slot" data-time="16:00">04:00 PM</div>
                        </div>
                    </div>
                </div>
                
                <!-- ADDED: Follow-up Method Field -->
                <div class="form-group">
                    <label for="followUpMethod" class="required">Preferred Follow-up Method</label>
                    <select id="followUpMethod" name="followUpMethod" required>
                        <option value="">Select follow-up method</option>
                        <option value="Email">Email</option>
                        <option value="Phone">Phone Call</option>
                        <option value="Text">Text Message</option>
                        <option value="In-Person">In-Person Meeting</option>
                    </select>
                </div>
            </div>

            <div class="card">
                <h2>About You</h2>
                <div class="form-group">
                    <label class="required">Current Mood</label>
                    <div class="mood-multiselect">
                        <div class="mood-select-display" id="moodSelectDisplay">
                            <span class="placeholder-text">Select your moods</span>
                        </div>
                        <div class="mood-options" id="moodOptions">
                            <div class="mood-option">
                                <input type="checkbox" id="moodAnxious" value="Anxious">
                                <label for="moodAnxious">Anxious</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodExcited" value="Excited">
                                <label for="moodExcited">Excited</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodHappy" value="Happy">
                                <label for="moodHappy">Happy</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodNeutral" value="Neutral">
                                <label for="moodNeutral">Neutral</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodPlayful" value="Playful">
                                <label for="moodPlayful">Playful</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodRelaxed" value="Relaxed">
                                <label for="moodRelaxed">Relaxed</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodSad" value="Sad">
                                <label for="moodSad">Sad</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodStressed" value="Stressed">
                                <label for="moodStressed">Stressed</label>
                            </div>
                            <div class="mood-option">
                                <input type="checkbox" id="moodWarm" value="Warm">
                                <label for="moodWarm">Warm</label>
                            </div>
                            <input type="hidden" id="currentMoodHidden" name="currentMood" value="">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="reason" class="required">Reason for Session</label>
                    <textarea id="reason" name="reason" placeholder="Briefly explain why you want to attend this session." required></textarea>
                </div>

                <div class="form-group">
                    <label for="additionalNotes">Additional Notes (Optional)</label>
                    <textarea id="additionalNotes" name="additionalNotes" placeholder="Any extra information or preferences."></textarea>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <a href="counseling?action=viewSessions" class="cancel-btn">
                <i class="fas fa-times"></i> Cancel
            </a>
            <button type="submit" class="submit-btn">
                <i class="fas fa-check"></i> Book Session
            </button>
        </div>
    </form>
</div>

<script>
    // ---------- Calendar JS ----------
    let currentDate = new Date();
    const calendarGrid = document.getElementById("calendarGrid");
    const currentMonthDiv = document.getElementById("currentMonth");
    const sessionDateInput = document.getElementById("sessionDate");

    function renderCalendar() {
        calendarGrid.innerHTML = "";
        let month = currentDate.getMonth();
        let year = currentDate.getFullYear();
        currentMonthDiv.textContent = currentDate.toLocaleString('default', { month: 'long', year: 'numeric' });

        let firstDay = new Date(year, month, 1);
        let lastDay = new Date(year, month + 1, 0);
        let startDay = firstDay.getDay(); // Sunday=0

        // Fill leading blank days
        for (let i = 0; i < startDay; i++) {
            const div = document.createElement("div");
            div.className = "calendar-day other-month";
            calendarGrid.appendChild(div);
        }

        // Fill current month
        const today = new Date();
        for (let d = 1; d <= lastDay.getDate(); d++) {
            const div = document.createElement("div");
            div.className = "calendar-day";
            div.textContent = d;
            const dayDate = new Date(year, month, d);

            // Disable past dates
            if(dayDate < new Date(today.getFullYear(), today.getMonth(), today.getDate())){
                div.classList.add("disabled");
            } else {
                div.addEventListener("click", function() {
                    document.querySelectorAll(".calendar-day").forEach(function(c) {
                        c.classList.remove("selected");
                    });
                    div.classList.add("selected");
                    // Use string concatenation instead of template literals
                    var monthStr = ("0" + (month + 1)).slice(-2);
                    var dayStr = ("0" + d).slice(-2);
                    sessionDateInput.value = year + "-" + monthStr + "-" + dayStr;
                });
            }
            calendarGrid.appendChild(div);
        }
    }

    document.getElementById("prevMonth").addEventListener("click", function() { 
        currentDate.setMonth(currentDate.getMonth() - 1); 
        renderCalendar(); 
    });

    document.getElementById("nextMonth").addEventListener("click", function() { 
        currentDate.setMonth(currentDate.getMonth() + 1); 
        renderCalendar(); 
    });

    renderCalendar();

    // ---------- Time slot selection ----------
    document.querySelectorAll(".time-slot").forEach(function(slot) {
        slot.addEventListener("click", function() {
            document.querySelectorAll(".time-slot").forEach(function(s) {
                s.classList.remove("selected");
            });
            slot.classList.add("selected");
            document.getElementById("sessionTime").value = slot.dataset.time;
        });
    });

    // ---------- Mood multi-select ----------
    const moodSelectWrapper = document.querySelector(".mood-multiselect");
    const moodDisplay = document.getElementById("moodSelectDisplay");
    const moodOptions = document.getElementById("moodOptions");
    const currentMoodHidden = document.getElementById("currentMoodHidden");

    // Toggle dropdown when clicking the display area
    moodDisplay.addEventListener("click", function(e) {
        e.stopPropagation();
        moodSelectWrapper.classList.toggle("open");
    });

    // Handle checkbox changes
    moodOptions.querySelectorAll("input[type=checkbox]").forEach(function(checkbox) {
        checkbox.addEventListener("change", function() {
            updateMoodDisplay();
        });
    });

    function updateMoodDisplay() {
        const selected = [];
        moodDisplay.innerHTML = "";
        
        moodOptions.querySelectorAll("input[type=checkbox]:checked").forEach(function(cb) {
            selected.push(cb.value);
            
            const tag = document.createElement("div");
            tag.className = "mood-tag";
            tag.textContent = cb.value;

            const removeBtn = document.createElement("span");
            removeBtn.className = "remove";
            removeBtn.textContent = "×";
            removeBtn.addEventListener("click", function(e) {
                e.stopPropagation();
                cb.checked = false;
                updateMoodDisplay();
            });

            tag.appendChild(removeBtn);
            moodDisplay.appendChild(tag);
        });

        // Add placeholder if none selected
        if(selected.length === 0) {
            const placeholder = document.createElement("span");
            placeholder.className = "placeholder-text";
            placeholder.textContent = "Select your moods";
            moodDisplay.appendChild(placeholder);
        }

        // Update hidden input value
        currentMoodHidden.value = selected.join(",");
    }

    // Close dropdown when clicking outside
    document.addEventListener("click", function() {
        moodSelectWrapper.classList.remove("open");
    });

    // Prevent dropdown from closing when clicking inside options
    moodOptions.addEventListener("click", function(e) {
        e.stopPropagation();
    });

    // ---------- Enhanced Form validation ----------
    document.getElementById("bookingForm").addEventListener("submit", function(e) {
        console.log("=== FORM SUBMISSION DEBUG ===");
        
        let isValid = true;
        let errorMessages = [];
        
        // Check if date is selected
        if (!sessionDateInput.value) {
            errorMessages.push("Please select a date");
            isValid = false;
        }
        
        // Check if time is selected
        const timeValue = document.getElementById("sessionTime").value;
        if (!timeValue) {
            errorMessages.push("Please select a time slot");
            isValid = false;
        }
        
        // Check if session type is selected
        const sessionTypeValue = document.getElementById("sessionType").value;
        if (!sessionTypeValue) {
            errorMessages.push("Please select a session type");
            isValid = false;
        }
        
        // Check if mood is selected
        const moodValue = document.getElementById("currentMoodHidden").value;
        if (!moodValue) {
            errorMessages.push("Please select at least one mood");
            isValid = false;
        }
        
        // Check if reason is filled
        const reasonValue = document.getElementById("reason").value.trim();
        if (!reasonValue) {
            errorMessages.push("Please provide a reason for the session");
            isValid = false;
        }
        
        // Check if followUpMethod is selected
        const followUpMethod = document.getElementById("followUpMethod");
        if (!followUpMethod || !followUpMethod.value) {
            errorMessages.push("Please select a follow-up method");
            isValid = false;
        }
        
        // Debug: Log all values
        console.log("Form values:");
        console.log("Date:", sessionDateInput.value);
        console.log("Time:", timeValue);
        console.log("Session Type:", sessionTypeValue);
        console.log("Mood:", moodValue);
        console.log("Reason:", reasonValue);
        console.log("Follow-up Method:", followUpMethod ? followUpMethod.value : "NOT FOUND");
        
        if (!isValid) {
            e.preventDefault();
            alert(errorMessages.join("\n"));
            return false;
        }
        
        // Show loading state
        const submitBtn = document.querySelector(".submit-btn");
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Booking...';
        submitBtn.disabled = true;

        // Log form data
        const formData = new FormData(this);
        console.log("Form data being submitted:");
        for (let [key, value] of formData.entries()) {
            console.log(key + ": " + value);
        }
        
        return true;
    });
</script>
</body>
</html>