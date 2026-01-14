<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.CounselingSession" %>
<%
    CounselingSession sessionObj = (CounselingSession) request.getAttribute("session");
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
            width: 150px;
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

        .calendar-container {
            background: #fff6da;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #E8D4B9;
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
            cursor: not-allowed;
        }

        .calendar-day.disabled {
            color: #D3C1A7;
            cursor: not-allowed;
            background: #F5F5F5;
        }

        .time-slots {
            display: grid;
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

        .next-session-section {
            display: none;
            margin-top: 20px;
            padding: 20px;
            background: #fffaf0;
            border-radius: 10px;
            border: 2px solid #E8D4B9;
        }

        /* Responsive design */
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
    <a href="<%= request.getContextPath() %>/modules/userManagementModule/dashboards/studentDashboard.jsp" class="home-link">
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
                <div class="info-value"><%= sessionObj.getFormattedDateTime() %></div>
            </div>
        </div>

        <form action="counseling" method="post" id="documentationForm">
            <input type="hidden" name="action" value="submitDocumentation">
            <input type="hidden" name="sessionId" value="<%= sessionObj.getSessionId() %>">
            <input type="hidden" name="nextSessionDate" id="nextSessionDate">
            <input type="hidden" name="nextSessionTime" id="nextSessionTime">

            <div class="form-group">
                <label for="summary" class="required">Session Summary</label>
                <textarea id="summary" name="summary" placeholder="Provide a summary of the session..." required></textarea>
            </div>

            <div class="form-group">
                <label for="observedMood" class="required">Mood / Progress Notes</label>
                <select id="observedMood" name="observedMood" required>
                    <option value="">Select student's observed mood</option>
                    <option value="Improved - Positive">Improved - Positive</option>
                    <option value="Stable - Neutral">Stable - Neutral</option>
                    <option value="Anxious - Nervous">Anxious - Nervous</option>
                    <option value="Depressed - Low">Depressed - Low</option>
                    <option value="Angry - Frustrated">Angry - Frustrated</option>
                    <option value="Mixed - Fluctuating">Mixed - Fluctuating</option>
                    <option value="Engaged - Participative">Engaged - Participative</option>
                    <option value="Withdrawn - Quiet">Withdrawn - Quiet</option>
                </select>
            </div>

            <div class="form-group">
                <label for="followUpActions" class="required">Follow-Up Actions / Recommendations</label>
                <textarea id="followUpActions" name="followUpActions" placeholder="List any follow-up actions or recommendations..." required></textarea>
            </div>

            <div class="form-group">
                <label for="attachment">Attachment (Optional)</label>
                <div class="file-upload" onclick="document.getElementById('fileInput').click()">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <div>Click to upload file or drag and drop</div>
                    <div style="font-size: 12px; color: #8B7355; margin-top: 5px;">PDF, DOC, JPG, PNG (Max 10MB)</div>
                    <input type="file" id="fileInput" class="file-input" name="attachment">
                </div>
                <div id="fileName" style="margin-top: 10px; font-size: 14px; color: #6B4F36;"></div>
            </div>

            <div class="form-group">
                <label for="nextSessionSuggested">Next Session Suggested (If needed)</label>
                <select id="nextSessionSuggested" name="nextSessionSuggested" onchange="toggleNextSessionSection()">
                    <option value="No">No, not needed</option>
                    <option value="Yes">Yes, schedule next session</option>
                </select>
            </div>

            <div id="nextSessionSection" class="next-session-section">
                <h3 style="margin-bottom: 15px; color: #6B4F36;">Schedule Next Session</h3>
                <div class="calendar-container">
                    <div class="calendar-header">
                        <h3>Select Date</h3>
                        <div class="calendar-nav">
                            <button type="button" id="prevMonth">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <span id="currentMonth"></span>
                            <button type="button" id="nextMonth">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                    <div class="calendar-grid" id="calendar">
                        <!-- Calendar will be populated by JavaScript -->
                    </div>
                    <div id="timeSlots" style="display: none;">
                        <h4 style="margin-bottom: 15px; color: #6B4F36; font-size: 16px;">Select Time</h4>
                        <div class="time-slots" id="timeSlotContainer">
                            <!-- Time slots will be populated by JavaScript -->
                        </div>
                    </div>
                </div>
            </div>

            <div class="actions">
                <a href="counseling?action=professionalSessions" class="btn secondary-btn">
                    <i class="fas fa-times"></i> Cancel
                </a>
                <button type="submit" class="btn primary-btn">
                    <i class="fas fa-save"></i> Submit Documentation
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // File upload display
    document.getElementById('fileInput').addEventListener('change', function(e) {
        const fileName = document.getElementById('fileName');
        if (this.files.length > 0) {
            fileName.textContent = 'Selected file: ' + this.files[0].name;
        } else {
            fileName.textContent = '';
        }
    });

    // Next session section toggle
    function toggleNextSessionSection() {
        const nextSessionSection = document.getElementById('nextSessionSection');
        const nextSessionSuggested = document.getElementById('nextSessionSuggested').value;
        nextSessionSection.style.display = nextSessionSuggested === 'Yes' ? 'block' : 'none';
    }

    // Calendar functionality
    let currentDate = new Date();
    let selectedDate = null;
    let selectedTime = null;

    function renderCalendar() {
        const calendar = document.getElementById('calendar');
        const currentMonth = document.getElementById('currentMonth');
        
        currentMonth.textContent = currentDate.toLocaleString('default', { month: 'long', year: 'numeric' });
        calendar.innerHTML = '';
        
        // Add day headers
        const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        days.forEach(day => {
            const dayHeader = document.createElement('div');
            dayHeader.textContent = day;
            dayHeader.style.fontWeight = '600';
            dayHeader.style.color = '#6B4F36';
            dayHeader.style.textAlign = 'center';
            dayHeader.style.padding = '8px 2px';
            calendar.appendChild(dayHeader);
        });
        
        const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        const startingDay = firstDay.getDay();
        const lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
        const daysInMonth = lastDay.getDate();
        
        for (let i = 0; i < startingDay; i++) {
            const emptyDay = document.createElement('div');
            emptyDay.classList.add('calendar-day', 'other-month');
            calendar.appendChild(emptyDay);
        }
        
        for (let day = 1; day <= daysInMonth; day++) {
            const dayElement = document.createElement('div');
            dayElement.classList.add('calendar-day');
            dayElement.textContent = day;
            
            const dateStr = `${currentDate.getFullYear()}-${(currentDate.getMonth() + 1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
            dayElement.dataset.date = dateStr;
            
            if (selectedDate === dateStr) {
                dayElement.classList.add('selected');
            }
            
            const today = new Date();
            const minDate = new Date();
            minDate.setDate(today.getDate() + 1); // Can schedule from tomorrow
            
            const cellDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), day);
            
            if (cellDate >= minDate) {
                dayElement.addEventListener('click', () => selectDate(dateStr, dayElement));
            } else {
                dayElement.classList.add('disabled');
            }
            
            calendar.appendChild(dayElement);
        }
    }

    function selectDate(date, element) {
        document.querySelectorAll('.calendar-day.selected').forEach(el => {
            el.classList.remove('selected');
        });
        element.classList.add('selected');
        selectedDate = date;
        document.getElementById('timeSlots').style.display = 'block';
        renderTimeSlots();
    }

    function renderTimeSlots() {
        const timeSlotContainer = document.getElementById('timeSlotContainer');
        timeSlotContainer.innerHTML = '';
        
        const timeSlots = [
            '09:00', '10:00', '11:00', '14:00', 
            '15:00', '16:00', '17:00', '18:00'
        ];
        
        timeSlots.forEach(time => {
            const timeSlot = document.createElement('div');
            timeSlot.classList.add('time-slot');
            timeSlot.textContent = time;
            
            if (selectedTime === time) {
                timeSlot.classList.add('selected');
            }
            
            timeSlot.addEventListener('click', () => {
                document.querySelectorAll('.time-slot.selected').forEach(el => {
                    el.classList.remove('selected');
                });
                timeSlot.classList.add('selected');
                selectedTime = time;
                document.getElementById('nextSessionDate').value = selectedDate;
                document.getElementById('nextSessionTime').value = selectedTime + ':00';
            });
            
            timeSlotContainer.appendChild(timeSlot);
        });
    }

    // Initialize calendar
    document.getElementById('prevMonth').addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
    });

    document.getElementById('nextMonth').addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
    });

    // Form validation
    document.getElementById('documentationForm').addEventListener('submit', function(e) {
        const nextSessionSuggested = document.getElementById('nextSessionSuggested').value;
        
        if (nextSessionSuggested === 'Yes' && (!selectedDate || !selectedTime)) {
            e.preventDefault();
            alert('Please select both date and time for the next session.');
            return;
        }
    });

    renderCalendar();
</script>
</body>
</html>