<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.CounselingSession" %>
<%@ page import="smilespace.model.Student" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    CounselingSession sessionObj = (CounselingSession) request.getAttribute("session");
    Student student = (Student) request.getAttribute("student");
    
    if (sessionObj == null || student == null) {
        response.sendRedirect("counseling?action=professionalSessions");
        return;
    }
    
    String formattedSessionDate = "";
    if (sessionObj.getScheduledDateTime() != null) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
        formattedSessionDate = sessionObj.getScheduledDateTime().format(formatter);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Post-Session Documentation - SmileSpace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Preahvihear&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Keep all your CSS exactly as it was */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background-color: #FFF8E8;
            font-family: 'Inter', sans-serif;
            color: #6B4F36;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }
        .container {
            width: 90%;
            max-width: 900px;
            margin-top: 3%;
            margin-bottom: 5%;
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
            font-family: 'Preahvihear', sans-serif;
            font-size: 36px;
            font-weight: 600;
            text-align: center;
            margin-bottom: 10px;
            color: #6B4F36;
        }
        .subtitle {
            font-size: 18px;
            margin-bottom: 40px;
            text-align: center;
            font-weight: 400;
            color: #CF8224;
        }
        .card {
            background: #FFF3C8;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 25px;
            box-shadow: 0px 4px 15px rgba(107, 79, 54, 0.1);
        }
        .session-info {
            background: #fff6da;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #E8D4B9;
            margin-bottom: 30px;
        }
        .info-row {
            display: flex;
            margin-bottom: 10px;
        }
        .info-label {
            font-weight: 600;
            color: #7e5625;
            width: 220px;
            flex-shrink: 0;
        }
        .info-value {
            color: #6B4F36;
            flex: 1;
        }
        .form-group {
            margin-bottom: 25px;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 10px;
            color: #6B4F36;
            font-size: 15px;
        }
        label.required::after {
            content: " *";
            color: #E74C3C;
        }
        textarea, select, input {
            width: 100%;
            padding: 12px;
            border: 2px solid #E8D4B9;
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            background: white;
            color: #6B4F36;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        textarea:focus, select:focus, input:focus {
            outline: none;
            border-color: #D7923B;
            box-shadow: 0 0 0 3px rgba(215, 146, 59, 0.2);
        }
        textarea {
            height: 120px;
            resize: vertical;
        }
        .file-upload {
            border: 2px dashed #E8D4B9;
            padding: 20px;
            text-align: center;
            border-radius: 10px;
            background: #fffaf0;
            cursor: pointer;
            transition: all 0.3s;
        }
        .file-upload:hover {
            border-color: #D7923B;
            background: #fff6e8;
        }
        .file-upload i {
            font-size: 24px;
            color: #D7923B;
            margin-bottom: 10px;
        }
        .file-input {
            display: none;
        }
        
        /* Observed Mood Styles (similar to booking form) */
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
        
        .calendar-container {
            background: #fff6da;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #E8D4B9;
            display: none;
            margin-top: 20px;
        }
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .calendar-header h3 {
            margin: 0;
            color: #6B4F36;
            font-size: 16px;
            font-weight: 600;
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
        }
        .calendar-nav button:hover {
            background: #C77D2F;
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
            padding: 10px 5px;
            text-align: center;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            font-weight: 500;
        }
        .calendar-day:hover {
            background: #FFEBB5;
        }
        .calendar-day.selected {
            background: #D7923B;
            color: white;
        }
        .calendar-day.other-month {
            color: #A88C6D;
        }
        .calendar-day.disabled {
            color: #D3C1A7;
            cursor: not-allowed;
            background: #F5F5F5;
        }
        .calendar-day.disabled:hover {
            background: #F5F5F5;
        }
        .time-slots {
            display: none;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 15px;
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
        }
        .time-slot.selected {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
        }
        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            font-size: 15px;
            font-family: 'Preahvihear', sans-serif;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        .primary-btn {
            background: #D7923B;
            color: white;
        }
        .primary-btn:hover {
            background: #C77D2F;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(215, 146, 59, 0.4);
        }
        .secondary-btn {
            background: #8B7355;
            color: white;
        }
        .secondary-btn:hover {
            background: #6B4F36;
            transform: translateY(-2px);
        }
        @media (max-width: 768px) {
            .card {
                padding: 25px;
            }
            .info-row {
                flex-direction: column;
                gap: 5px;
            }
            .info-label {
                width: 100%;
            }
            .time-slots {
                grid-template-columns: repeat(2, 1fr);
            }
            .actions {
                flex-direction: column;
            }
            .btn {
                width: 100%;
                justify-content: center;
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
    <h1>Post-Session Documentation</h1>
    <div class="subtitle">Document the session details and progress</div>

    <div class="card">
        <div class="session-info">
            <div class="info-row">
                <div class="info-label">Session ID:</div>
                <div class="info-value"><%= sessionObj.getSessionId() %></div>
            </div>
            <div class="info-row">
                <div class="info-label">Student ID:</div>
                <div class="info-value"><%= sessionObj.getStudentId() %></div>
            </div>
            <div class="info-row">
                <div class="info-label">Session Type:</div>
                <div class="info-value"><%= sessionObj.getSessionType() %></div>
            </div>
            <div class="info-row">
                <div class="info-label">Session Date:</div>
                <div class="info-value"><%= formattedSessionDate %></div>
            </div>
            <div class="info-row">
                <div class="info-label">Student Name:</div>
                <div class="info-value"><%= student.getFullName() %></div>
            </div>
            <!-- Show student's reported mood if available -->
            <% if (sessionObj.getCurrentMood() != null && !sessionObj.getCurrentMood().isEmpty()) { %>
            <div class="info-row">
                <div class="info-label">Student's Reported Mood:</div>
                <div class="info-value"><%= sessionObj.getCurrentMood() %></div>
            </div>
            <% } %>
        </div>

         <form action="<%= request.getContextPath() %>/counseling" method="post" id="documentationForm" enctype="multipart/form-data">
            <input type="hidden" name="action" value="submitDocumentation">
            <input type="hidden" name="sessionId" value="<%= sessionObj.getSessionId() %>">
            <input type="hidden" name="nextSessionDate" id="nextSessionDate">
            <input type="hidden" name="nextSessionTime" id="nextSessionTime">
            <!-- Hidden input for observed mood -->
            <input type="hidden" id="observedMoodHidden" name="observedMood" value="">

            <div class="form-group">
                <label for="summary" class="required">Session Summary</label>
                <textarea id="summary" name="summary" placeholder="Provide a summary of the session..." required></textarea>
            </div>

            <div class="form-group">
                <label for="progressNotes" class="required">Progress Notes</label>
                <textarea id="progressNotes" name="progressNotes" placeholder="Document the student's progress, observations, and any important notes..." required></textarea>
            </div>

            <!-- ADDED: Observed Mood Section -->
            <div class="form-group">
                <label>Observed Mood (Optional)</label>
                <div class="mood-multiselect">
                    <div class="mood-select-display" id="observedMoodDisplay">
                        <span class="placeholder-text">Select observed moods</span>
                    </div>
                    <div class="mood-options" id="observedMoodOptions">
                        <div class="mood-option">
                            <input type="checkbox" id="obsAnxious" value="Anxious">
                            <label for="obsAnxious">Anxious</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsCalm" value="Calm">
                            <label for="obsCalm">Calm</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsEngaged" value="Engaged">
                            <label for="obsEngaged">Engaged</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsHappy" value="Happy">
                            <label for="obsHappy">Happy</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsNeutral" value="Neutral">
                            <label for="obsNeutral">Neutral</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsReflective" value="Reflective">
                            <label for="obsReflective">Reflective</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsRelaxed" value="Relaxed">
                            <label for="obsRelaxed">Relaxed</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsSad" value="Sad">
                            <label for="obsSad">Sad</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsStressed" value="Stressed">
                            <label for="obsStressed">Stressed</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsWithdrawn" value="Withdrawn">
                            <label for="obsWithdrawn">Withdrawn</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsHopeful" value="Hopeful">
                            <label for="obsHopeful">Hopeful</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsFrustrated" value="Frustrated">
                            <label for="obsFrustrated">Frustrated</label>
                        </div>
                        <div class="mood-option">
                            <input type="checkbox" id="obsMotivated" value="Motivated">
                            <label for="obsMotivated">Motivated</label>
                        </div>
                    </div>
                </div>
                <div style="font-size: 12px; color: #8B7355; margin-top: 5px;">
                    <i class="fas fa-info-circle"></i> Select the moods you observed during the session
                </div>
            </div>

            <div class="form-group">
                <label for="followUpActions" class="required">Follow-Up Actions / Recommendations</label>
                <textarea id="followUpActions" name="followUpActions" placeholder="List any follow-up actions or recommendations..." required></textarea>
            </div>

            <div class="form-group">
                <label for="attachment">Attachment (Optional)</label>
                <div class="file-upload" onclick="document.getElementById('attachmentFile').click()">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <div>Click to upload file or drag and drop</div>
                    <div style="font-size: 12px; color: #8B7355; margin-top: 5px;">PDF, DOC, JPG, PNG (Max 10MB)</div>
                </div>
                <input type="file" id="attachmentFile" class="file-input" name="attachment" 
                       accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" 
                       onchange="document.getElementById('fileName').textContent = this.files[0] ? this.files[0].name : 'No file chosen'">
                <div id="fileName" style="margin-top: 10px; font-size: 14px; color: #6B4F36;">
                    No file chosen
                </div>
            </div>

            <!-- <div class="form-group">
                <label for="nextSessionSuggested">Next Session Suggested (If needed)</label>
                <select id="nextSessionSuggested" name="nextSessionSuggested" onchange="toggleCalendar()">
                    <option value="No">No, not needed</option>
                    <option value="Yes">Yes, schedule next session</option>
                </select>
            </div>

            <div id="calendarContainer" class="calendar-container">
                <h3 style="margin-bottom: 15px; color: #6B4F36;">Schedule Next Session</h3>

                <div style="margin-bottom: 20px;">
                    <label>Select Date:</label>
                    <input type="date" id="nextSessionDateInput" 
                           onchange="document.getElementById('nextSessionDate').value = this.value; showTimeSlots()"
                           style="margin-top: 5px;" 
                           min="<%= java.time.LocalDate.now().plusDays(1).toString() %>">
                </div>
                
                <div id="timeSlotsContainer" style="display: none;">
                    <label>Select Time:</label>
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 10px;">
                        <div class="time-slot" onclick="selectTime(this, '09:00')">09:00</div>
                        <div class="time-slot" onclick="selectTime(this, '10:00')">10:00</div>
                        <div class="time-slot" onclick="selectTime(this, '11:00')">11:00</div>
                        <div class="time-slot" onclick="selectTime(this, '12:00')">12:00</div>
                        <div class="time-slot" onclick="selectTime(this, '14:00')">14:00</div>
                        <div class="time-slot" onclick="selectTime(this, '15:00')">15:00</div>
                        <div class="time-slot" onclick="selectTime(this, '16:00')">16:00</div>
                        <div class="time-slot" onclick="selectTime(this, '17:00')">17:00</div>
                        <div class="time-slot" onclick="selectTime(this, '18:00')">18:00</div>
                    </div>
                </div>
            </div> -->

            <div class="actions">
                <a href="<%= request.getContextPath() %>/counseling?action=professionalSessions" class="btn secondary-btn">
                    <i class="fas fa-times"></i> Cancel
                </a>
                <button type="submit" class="btn primary-btn" onclick="return validateForm()">
                    <i class="fas fa-save"></i> Submit Documentation
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // OBSERVED MOOD MULTI-SELECT
    const moodSelectWrapper = document.querySelector(".mood-multiselect");
    const moodDisplay = document.getElementById("observedMoodDisplay");
    const moodOptions = document.getElementById("observedMoodOptions");
    const observedMoodHidden = document.getElementById("observedMoodHidden");

    // Toggle dropdown when clicking the display area
    moodDisplay.addEventListener("click", function(e) {
        e.stopPropagation();
        moodSelectWrapper.classList.toggle("open");
    });

    // Handle checkbox changes
    moodOptions.querySelectorAll("input[type=checkbox]").forEach(function(checkbox) {
        checkbox.addEventListener("change", function() {
            updateObservedMoodDisplay();
        });
    });

    function updateObservedMoodDisplay() {
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
                updateObservedMoodDisplay();
            });

            tag.appendChild(removeBtn);
            moodDisplay.appendChild(tag);
        });

        // Add placeholder if none selected
        if(selected.length === 0) {
            const placeholder = document.createElement("span");
            placeholder.className = "placeholder-text";
            placeholder.textContent = "Select observed moods";
            moodDisplay.appendChild(placeholder);
        }

        // Update hidden input value
        observedMoodHidden.value = selected.join(",");
        console.log("Observed mood selected:", observedMoodHidden.value);
    }

    // Close dropdown when clicking outside
    document.addEventListener("click", function() {
        moodSelectWrapper.classList.remove("open");
    });

    // Prevent dropdown from closing when clicking inside options
    moodOptions.addEventListener("click", function(e) {
        e.stopPropagation();
    });

    // CALENDAR TOGGLE
    function toggleCalendar() {
        var select = document.getElementById('nextSessionSuggested');
        var calendarContainer = document.getElementById('calendarContainer');
        
        if (select.value === 'Yes') {
            calendarContainer.style.display = 'block';
            console.log("Calendar shown");
        } else {
            calendarContainer.style.display = 'none';
            console.log("Calendar hidden");
            // Clear selections
            document.getElementById('nextSessionDateInput').value = '';
            document.getElementById('nextSessionDate').value = '';
            document.getElementById('nextSessionTime').value = '';
            document.getElementById('timeSlotsContainer').style.display = 'none';
            
            // Clear time slot selections
            var timeSlots = document.querySelectorAll('.time-slot');
            timeSlots.forEach(function(slot) {
                slot.classList.remove('selected');
            });
        }
    }

    // SHOW TIME SLOTS WHEN DATE SELECTED
    function showTimeSlots() {
        document.getElementById('timeSlotsContainer').style.display = 'block';
        console.log("Time slots shown");
    }

    // SELECT TIME
    function selectTime(element, time) {
        // Clear previous selection
        var timeSlots = document.querySelectorAll('.time-slot');
        timeSlots.forEach(function(slot) {
            slot.classList.remove('selected');
        });
        
        // Select this time
        element.classList.add('selected');
        
        // Set hidden input value
        document.getElementById('nextSessionTime').value = time + ':00';
        console.log("Time selected:", time);
    }

    // FORM VALIDATION
    function validateForm() {
        console.log("=== Form Validation ===");
        
        // Check required fields
        var summary = document.getElementById('summary').value.trim();
        var progressNotes = document.getElementById('progressNotes').value.trim();
        var followUpActions = document.getElementById('followUpActions').value.trim();
        
        if (!summary) {
            alert('Please provide a session summary.');
            return false;
        }
        
        if (!progressNotes) {
            alert('Please provide progress notes.');
            return false;
        }
        
        if (!followUpActions) {
            alert('Please provide follow-up actions/recommendations.');
            return false;
        }
        
        var nextSessionSuggested = document.getElementById('nextSessionSuggested').value;
        
        if (nextSessionSuggested === 'Yes') {
            var nextSessionDate = document.getElementById('nextSessionDate').value;
            var nextSessionTime = document.getElementById('nextSessionTime').value;
            
            if (!nextSessionDate || !nextSessionTime) {
                alert('Please select both date and time for the next session.');
                return false;
            }
        }
        
        // File size validation
        var fileInput = document.getElementById('attachmentFile');
        if (fileInput.files.length > 0) {
            var file = fileInput.files[0];
            var maxSize = 10 * 1024 * 1024; // 10MB
            
            if (file.size > maxSize) {
                alert('File size exceeds 10MB limit. Please choose a smaller file.');
                return false;
            }
        }
        
        // Log observed mood for debugging
        console.log("Observed mood to be saved:", observedMoodHidden.value);
        
        return true;
    }

    window.onload = function() {
        console.log("Page loaded - JavaScript is working!");
        updateObservedMoodDisplay();
    };
</script>

</body>
</html>