<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="smilespace.model.MoodWeeklySummary" %>
<%@ page import="smilespace.model.MoodEntry" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.YearMonth" %>
<%
    MoodWeeklySummary weeklySummary = (MoodWeeklySummary) request.getAttribute("weeklySummary");
    List<MoodEntry> allMoodEntries = (List<MoodEntry>) request.getAttribute("allMoodEntries");
    Map<String, Integer> moodTrends = (Map<String, Integer>) request.getAttribute("moodTrends");
    String period = (String) request.getAttribute("selectedPeriod");
    if (period == null) period = "week";
    
    if (weeklySummary == null) {
        weeklySummary = new MoodWeeklySummary();
    }
    if (allMoodEntries == null) {
        allMoodEntries = new ArrayList<>();
    }
    if (moodTrends == null) {
        moodTrends = new HashMap<>();
    }
    
    // Generate dates based on selected period
    LocalDate startDate;
    LocalDate endDate;
    String periodTitle;
    
    if ("month".equals(period)) {
        startDate = LocalDate.now().withDayOfMonth(1);
        endDate = YearMonth.from(startDate).atEndOfMonth();
        periodTitle = startDate.format(DateTimeFormatter.ofPattern("MMMM yyyy")) + " Monthly Mood Summary";
    } else {
        // Default to week
        startDate = LocalDate.now().with(java.time.DayOfWeek.MONDAY);
        endDate = startDate.plusDays(6);
        periodTitle = startDate.format(DateTimeFormatter.ofPattern("d MMM")) + " - " + 
                     endDate.format(DateTimeFormatter.ofPattern("d MMM yyyy")) + " Week's Mood Summary";
    }
    
    DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("d MMM");
    DateTimeFormatter dayFormat = DateTimeFormatter.ofPattern("E");
    DateTimeFormatter dateFormatShort = DateTimeFormatter.ofPattern("d MMM");
    DateTimeFormatter keyFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter monthFormat = DateTimeFormatter.ofPattern("MMMM yyyy");
    DateTimeFormatter displayDateFormat = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
    
    // Calculate summary data manually for debugging
    String dominantMood = "No data";
    String frequentTags = "No tags";
    double moodStability = 0.0;
    String stabilityText = "Some variations";
    
    if (!allMoodEntries.isEmpty()) {
        // Calculate dominant mood
        Map<String, Integer> moodCounts = new HashMap<>();
        for (MoodEntry entry : allMoodEntries) {
            if (entry.getFeelings() != null) {
                for (String feeling : entry.getFeelings()) {
                    moodCounts.put(feeling, moodCounts.getOrDefault(feeling, 0) + 1);
                }
            }
        }
        
        if (!moodCounts.isEmpty()) {
            dominantMood = moodCounts.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .get().getKey();
        }
        
        // Calculate frequent tags
        Map<String, Integer> tagCounts = new HashMap<>();
        for (MoodEntry entry : allMoodEntries) {
            if (entry.getTags() != null) {
                for (String tag : entry.getTags()) {
                    tagCounts.put(tag, tagCounts.getOrDefault(tag, 0) + 1);
                }
            }
        }
        
        if (!tagCounts.isEmpty()) {
            List<String> topTags = tagCounts.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .limit(3)
                .map(Map.Entry::getKey)
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
            frequentTags = String.join(", ", topTags);
        }
        
        // Simple stability calculation
        moodStability = allMoodEntries.size() >= 2 ? 75.0 : 50.0;
        stabilityText = moodStability >= 70 ? "Low fluctuations" : "Some variations";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Mood Trends</title>
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
            width: 90%;
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
            margin-bottom: 1px;
            padding-bottom: 0;
        }

        /* Navigation Buttons */
        .nav-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            margin-top: 0;
        }

        .backbtn {
            margin-top: 30px;
            margin-bottom: 0;
        }

        .back-to-mood-btn {
            background: #D7923B;
            border: none;
            padding: 12px 25px;
            font-size: 15px;
            border-radius: 40px;
            color: white;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-to-mood-btn:hover {
            background: #c77d2f;
            text-decoration: none;
            color: white;
        }

        /* Time Period Selector */
        .time-period {
            display: flex;
            gap: 15px;
        }

        .period-btn {
            font-family: 'Preahvihear', sans-serif;
            background: #FFF3C8;
            border: 2.5px solid #D4A46D;
            padding: 5px 18px;
            font-size: 14px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            color: #6B4F36;
            transition: all 0.2s;
            margin: 0;
        }

        .period-btn.active {
            background: #D7923B;
            color: white;
            border-color: #D7923B;
        }

        .period-btn:hover {
            background: #D7923B;
            color: white;
        }

        /* Week Summary */
        .week-summary {
            background: #FFF3C8;
            padding: 18px 25px;
            border-radius: 15px;
            margin-bottom: 30px;
        }

        .week-range {
            font-size: 17px;
            font-weight: 600;
            color: #6B4F36;
            margin-bottom: 15px;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
        }

        .summary-item {
            text-align: center;
        }

        .summary-label {
            font-size: 14px;
            color: #8B7355;
            margin-bottom: 3px;
        }

        .summary-value {
            font-size: 15px;
            font-weight: 600;
            color: #6B4F36;
        }

        /* Mood Calendar - Weekly View */
        .mood-calendar {
            background: white;
            padding: 18px 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .calendar-title {
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #6B4F36;
        }

        .week-days {
            font-size: 14px;
            display: flex;
            justify-content: space-between;
            border-bottom: 2px solid #D4A46D;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }

        .day-column {
            text-align: center;
            flex: 1;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .day-column:hover {
            transform: translateY(-2px);
            background-color: #FFF8E8;
        }

        /* Monthly Layout */
        .monthly-layout {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            margin-bottom: 30px;
            align-items: start;
        }

        .month-summary {
            background: #FFF3C8;
            padding: 25px;
            border-radius: 15px;
            height: fit-content;
        }

        .month-title {
            font-size: 17px;
            font-weight: 600;
            color: #6B4F36;
            margin-bottom: 20px;
            text-align: center;
        }

        .month-summary-grid {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .month-summary-item {
            text-align: center;
            padding: 15px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(107, 79, 54, 0.1);
        }

        .month-summary-label {
            font-size: 14px;
            color: #8B7355;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .month-summary-value {
            font-size: 15px;
            font-weight: 600;
            color: #6B4F36;
            line-height: 1.4;
        }

        /* Monthly Calendar Grid - Smaller Version */
        .month-calendar {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .month-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 3px;
        }

        .calendar-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 3px;
            margin-bottom: 8px;
            text-align: center;
            font-weight: 600;
            color: #6B4F36;
        }

        .day-header {
            padding: 5px 2px;
            background: #FFF3C8;
            border-radius: 4px;
            font-size: 10px;
        }

        .calendar-day {
            aspect-ratio: 1;
            background: #f9f9f9;
            border: 1px solid #E8D4B9;
            border-radius: 4px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            cursor: pointer;
            transition: all 0.2s;
            padding: 2px 1px;
            position: relative;
            min-height: 45px;
        }

        .calendar-day:hover {
            transform: translateY(-1px);
            border-color: #D7923B;
            box-shadow: 0 2px 8px rgba(215, 146, 59, 0.3);
            background-color: #FFF8E8;
        }

        .day-number {
            font-size: clamp(11px, 1vw, 15px);
            font-weight: bold;
            color: #6B4F36;
            margin-bottom: 2px;
        }

        .day-moods {
            display: flex;
            flex-wrap: wrap;
            gap: 1px;
            align-items: center;
            justify-content: center;
            min-height: 20px;
            flex-grow: 1;
            width: 100%;
        }

        /* PNG Mood Icons for Monthly Calendar - Smaller */
        .mood-png-icon {
            width: clamp(26px, 2.5vw, 40px);
            height: clamp(26px, 2.5vw, 40px);
            border-radius: 50%;
            object-fit: cover;
            transition: transform 0.2s;
        }

        .mood-png-icon:hover {
            transform: scale(1.2);
        }

        .empty-day-small {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #f5f5f5;
            border: 1px dashed #D4A46D;
        }

        .other-month {
            background: #f8f8f8;
            border-color: #e8e8e8;
        }

        .other-month .day-number {
            color: #aaa;
        }

        .mood-icons-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            margin-bottom: 10px;
            min-height: 60px;
            justify-content: center;
        }

        .mood-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-size: cover;
            background-position: center;
            flex-shrink: 0;
            border: 2px solid #E8D4B9;
        }

        .mood-icon.single {
            width: 50px;
            height: 50px;
        }

        .empty-day {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #f5f5f5;
            border: 2px dashed #D4A46D;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8B7355;
            font-size: 12px;
        }

        .day-date {
            font-size: 14px;
            color: #8B7355;
            margin-top: 5px;
        }

        /* Insights */
        .insights {
            background: #E8F4F8;
            padding: 25px;
            padding-top: 3px;
            border-radius: 15px;
            border-left: 5px solid #4ECDC4;
        }

        .insights h3 {
            color: #2C7873;
            margin-bottom: 15px;
            font-size: 19px;
        }

        .insight-text {
            font-size: 15px;
            line-height: 1.6;
            color: #2C7873;
        }

        .no-mood {
            color: #8B7355;
            font-style: italic;
        }

        /* Monthly Layout with Insights */
        .monthly-main-content {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            align-items: start;
        }

        .monthly-left-panel {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: white;
            padding: 40px;
            border-radius: 15px;
            max-width: 450px;
            width: 90%;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            text-align: center;
        }

        .modal-title {
            color: #6B4F36;
            margin-bottom: 20px;
            font-size: 22px;
            font-weight: 600;
        }

        .modal-message {
            color: #8B7355;
            margin-bottom: 25px;
            font-size: 16px;
            line-height: 1.5;
        }

        .modal-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .modal-btn {
            padding: 12px 24px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-family: 'Preahvihear', sans-serif;
            font-weight: bold;
            font-size: 16px;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .modal-btn.primary {
            background: #D7923B;
            color: white;
        }

        .modal-btn.primary:hover {
            background: #c77d2f;
        }

        .modal-btn.secondary {
            background: #6B4F36;
            color: white;
        }

        .modal-btn.secondary:hover {
            background: #5a422d;
        }

        .modal-close-btn {
            margin-top: 15px;
            padding: 10px 20px;
            background: #8B7355;
            color: white;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-family: 'Preahvihear', sans-serif;
            font-size: 16px;
            font-weight: bold;
            transition: background 0.2s;
        }

        .modal-close-btn:hover {
            background: #7a6248;
        }

        /* Responsive Design for Monthly Layout */
        @media (min-width: 1200px) {
            .monthly-main-content {
                display: grid;
                grid-template-columns: 1fr 2fr;
                gap: 30px;
            }
            
            .monthly-left-panel {
                display: flex;
                flex-direction: column;
                gap: 30px;
            }
        }
        
        @media (max-width: 1199px) {
            .monthly-main-content {
                display: flex;
                flex-direction: column;
                gap: 30px;
                width: 100%;
            }
            
            .monthly-left-panel {
                display: contents;
            }
            
            .month-summary {
                order: 1;
                width: 100%;
                box-sizing: border-box;
            }
            
            .month-calendar {
                order: 2;
                width: 100%;
                box-sizing: border-box;
            }
            
            .insights {
                order: 3;
                width: 100%;
                box-sizing: border-box;
            }
        }
        
        @media (max-width: 768px) {
            .container {
                width: 95%;
                padding: 20px 0;
            }
            
            .month-summary {
                padding: 20px;
            }
            
            .month-calendar {
                padding: 15px;
            }
            
            .insights {
                padding: 20px;
            }
            
            .week-days {
                flex-wrap: wrap;
                gap: 10px;
            }
            
            .day-column {
                flex: 0 0 calc(33.333% - 10px);
                margin-bottom: 10px;
            }
            
            .month-grid {
                gap: 2px;
            }
            
            .calendar-day {
                min-height: 40px;
                padding: 1px;
            }
            
            .mood-png-icon {
                width: 12px;
                height: 12px;
            }
            
            .empty-day-small {
                width: 10px;
                height: 10px;
            }
            
            .day-number {
                font-size: 8px;
            }
            
            .modal-content {
                padding: 25px;
            }
            
            .modal-actions {
                flex-direction: column;
            }
            
            .modal-btn {
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
    <h1>My Mood Trends</h1>

    <!-- Navigation Buttons -->
    <div class="nav-buttons">        
        <!-- Time Period Selector -->
        <div class="time-period">
            <button class="period-btn <%= "week".equals(period) ? "active" : "" %>" onclick="changePeriod('week')">This Week</button>
            <button class="period-btn <%= "month".equals(period) ? "active" : "" %>" onclick="changePeriod('month')">This Month</button>
        </div>
    </div>

    <% if ("week".equals(period)) { %>
    <!-- Weekly View -->
    <!-- Summary -->
    <div class="week-summary">
        <div class="week-range"><%= periodTitle %></div>
        <div class="summary-grid">
            <div class="summary-item">
                <div class="summary-label">Dominant Mood</div>
                <div class="summary-value"><%= dominantMood %></div>
            </div>
            <div class="summary-item">
                <div class="summary-label">Most Frequent Tags</div>
                <div class="summary-value"><%= frequentTags %></div>
            </div>
            <div class="summary-item">
                <div class="summary-label">Mood Stability</div>
                <div class="summary-value"><%= String.format("%.1f", moodStability) %>% (<%= stabilityText %>)</div>
            </div>
        </div>
    </div>

    <!-- Weekly Calendar View -->
    <div class="mood-calendar">
        <div class="calendar-title">Weekly Mood Overview</div>
        <div class="week-days">
            <%
                for (int i = 0; i < 7; i++) {
                    LocalDate currentDate = startDate.plusDays(i);
                    String dateKey = currentDate.format(keyFormat);
                    String formattedDate = currentDate.format(displayDateFormat);
                    
                    // Find mood entry for this date
                    MoodEntry dayMood = null;
                    for (MoodEntry entry : allMoodEntries) {
                        if (entry.getEntryDate().equals(currentDate)) {
                            dayMood = entry;
                            break;
                        }
                    }
                    boolean hasMoodData = dayMood != null && dayMood.getFeelings() != null && !dayMood.getFeelings().isEmpty();
            %>
            <div class="day-column" 
                 data-date="<%= dateKey %>"
                 data-formatted-date="<%= formattedDate %>"
                 data-has-mood="<%= hasMoodData %>">
                <div class="mood-icons-container">
                    <%
                        if (hasMoodData) {
                            List<String> feelings = dayMood.getFeelings();
                            if (feelings.size() == 1) {
                    %>
                                <div class="mood-icon single" style="background-image: url('<%= request.getContextPath() %>/modules/moodAndWellnessModule/images/feelings/<%= feelings.get(0).toLowerCase() %>.png')"></div>
                    <%
                            } else {
                                for (String feeling : feelings) {
                    %>
                                    <div class="mood-icon" style="background-image: url('<%= request.getContextPath() %>/modules/moodAndWellnessModule/images/feelings/<%= feeling.toLowerCase() %>.png')"></div>
                    <%
                                }
                            }
                        } else {
                    %>
                            <div class="empty-day">No entry</div>
                    <%
                        }
                    %>
                </div>
                <div class="day-date">
                    <%= currentDate.format(dayFormat) %><br>
                    <%= currentDate.format(dateFormatShort) %>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Insights -->
    <div class="insights">
        <h3>💡 Weekly Insights</h3>
        <div class="insight-text">
            <% if (allMoodEntries.isEmpty()) { %>
            Start recording your moods to see insights here! Even just a few entries can help you understand your patterns.
            <% } else if (dominantMood.toLowerCase().contains("happy") || dominantMood.toLowerCase().contains("excited")) { %>
            You've been feeling great lately — keep nurturing what makes you happy! Stay connected with your friends and take small breaks to maintain this positive balance.
            <% } else if (dominantMood.toLowerCase().contains("stress") || dominantMood.toLowerCase().contains("anxious")) { %>
            It's been a challenging week. Remember to take breaks and practice self-care. You're doing better than you think!
            <% } else { %>
            Your mood patterns show a balanced week. Continue practicing mindfulness and acknowledging your feelings as they come.
            <% } %>
        </div>
    </div>

    <% } else if ("month".equals(period)) { %>
    <!-- Monthly View (Responsive layout) -->
    <div class="monthly-main-content">
        <!-- Left Panel: Summary and Insights -->
        <div class="monthly-left-panel">
            <!-- Monthly Summary -->
            <div class="month-summary">
                <div class="month-title"><%= periodTitle %></div>
                <div class="month-summary-grid">
                    <div class="month-summary-item">
                        <div class="month-summary-label">Dominant Mood</div>
                        <div class="month-summary-value"><%= dominantMood %></div>
                    </div>
                    <div class="month-summary-item">
                        <div class="month-summary-label">Most Frequent Tags</div>
                        <div class="month-summary-value"><%= frequentTags %></div>
                    </div>
                    <div class="month-summary-item">
                        <div class="month-summary-label">Mood Stability</div>
                        <div class="month-summary-value"><%= String.format("%.1f", moodStability) %>% (<%= stabilityText %>)</div>
                    </div>
                </div>
            </div>

            <!-- Insights -->
            <div class="insights">
                <h3>💡 Monthly Insights</h3>
                <div class="insight-text">
                    <% if (allMoodEntries.isEmpty()) { %>
                    Start recording your moods to see insights here! Even just a few entries can help you understand your patterns.
                    <% } else if (dominantMood.toLowerCase().contains("happy") || dominantMood.toLowerCase().contains("excited")) { %>
                    You've been feeling great this month — keep nurturing what makes you happy! Stay connected with your friends and take small breaks to maintain this positive balance.
                    <% } else if (dominantMood.toLowerCase().contains("stress") || dominantMood.toLowerCase().contains("anxious")) { %>
                    It's been a challenging month. Remember to take breaks and practice self-care. You're doing better than you think!
                    <% } else { %>
                    Your mood patterns show a balanced month. Continue practicing mindfulness and acknowledging your feelings as they come.
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Right Panel: Calendar -->
        <div class="month-calendar">
            <div class="calendar-title">Monthly Mood Overview - <%= startDate.format(monthFormat) %></div>
            
            <div class="calendar-header">
                <div class="day-header">Mon</div>
                <div class="day-header">Tue</div>
                <div class="day-header">Wed</div>
                <div class="day-header">Thu</div>
                <div class="day-header">Fri</div>
                <div class="day-header">Sat</div>
                <div class="day-header">Sun</div>
            </div>
            
            <div class="month-grid">
                <%
                    // Get first day of month and adjust to Monday start
                    LocalDate firstDay = startDate.withDayOfMonth(1);
                    int dayOfWeek = firstDay.getDayOfWeek().getValue(); // 1=Monday, 7=Sunday
                    
                    // Add days from previous month to fill the first week
                    for (int i = 1; i < dayOfWeek; i++) {
                        LocalDate prevMonthDay = firstDay.minusDays(dayOfWeek - i);
                %>
                        <div class="calendar-day other-month">
                            <div class="day-number"><%= prevMonthDay.getDayOfMonth() %></div>
                            <div class="day-moods">
                                <div class="empty-day-small"></div>
                            </div>
                        </div>
                <%
                    }
                    
                    // Add days of current month
                    int daysInMonth = YearMonth.from(firstDay).lengthOfMonth();
                    
                    for (int day = 1; day <= daysInMonth; day++) {
                        LocalDate calendarDate = firstDay.withDayOfMonth(day);
                        String dateKey = calendarDate.format(keyFormat);
                        String formattedDate = calendarDate.format(displayDateFormat);
                        
                        // Find mood entry for this date
                        MoodEntry dayMood = null;
                        for (MoodEntry entry : allMoodEntries) {
                            if (entry.getEntryDate().equals(calendarDate)) {
                                dayMood = entry;
                                break;
                            }
                        }
                        
                        boolean hasMoodData = dayMood != null && dayMood.getFeelings() != null && !dayMood.getFeelings().isEmpty();
                %>
                        <div class="calendar-day" 
                             data-date="<%= dateKey %>"
                             data-formatted-date="<%= formattedDate %>"
                             data-has-mood="<%= hasMoodData %>">
                            <div class="day-number"><%= day %></div>
                            <div class="day-moods">
                                <%
                                    if (hasMoodData) {
                                        List<String> feelings = dayMood.getFeelings();
                                        
                                        // Show up to 3 mood PNG icons
                                        for (int i = 0; i < Math.min(feelings.size(), 3); i++) {
                                            String feeling = feelings.get(i);
                                %>
                                            <img src="<%= request.getContextPath() %>/modules/moodAndWellnessModule/images/feelings/<%= feeling.toLowerCase() %>.png" 
                                                 alt="<%= feeling %>" 
                                                 class="mood-png-icon"
                                                 title="<%= feeling %>">
                                <%
                                        }
                                        if (feelings.size() > 3) {
                                %>
                                            <div style="font-size: 6px; color: #D7923B;" title="<%= feelings.size() - 3 %> more moods">+<%= feelings.size() - 3 %></div>
                                <%
                                        }
                                    } else {
                                %>
                                        <div class="empty-day-small" title="No mood entry"></div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                <%
                    }
                    
                    // Add days from next month to complete the last week
                    int totalCells = 42; // 6 rows × 7 days
                    int cellsUsed = dayOfWeek - 1 + daysInMonth;
                    int remainingCells = totalCells - cellsUsed;
                    
                    for (int i = 1; i <= remainingCells; i++) {
                %>
                        <div class="calendar-day other-month">
                            <div class="day-number"><%= i %></div>
                            <div class="day-moods">
                                <div class="empty-day-small"></div>
                            </div>
                        </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    <% } %>

    <div class="nav-buttons backbtn">
        <a href="mood" class="back-to-mood-btn">
            <i class="fas fa-arrow-left"></i>
            Back to Mood Tracker
        </a>
    </div>
</div>

<!-- Modal for daily mood details -->
<div id="dailyMoodModal" class="modal-overlay">
    <div class="modal-content">
        <h3 id="modalDate" class="modal-title"></h3>
        <div id="modalMessage" class="modal-message"></div>
        <div id="modalActions" class="modal-actions"></div>
        <button onclick="closeModal()" class="modal-close-btn">Close</button>
    </div>
</div>

<script>
    // Store current date globally so functions can access it
    let currentSelectedDate = '';
    
    // Show modal when clicking on a calendar day
    function showDateMood(element) {
        console.log("DEBUG: showDateMood called");
        
        // Get data from clicked element
        currentSelectedDate = element.getAttribute('data-date');
        const formattedDate = element.getAttribute('data-formatted-date');
        const hasMoodData = element.getAttribute('data-has-mood') === 'true';
        
        console.log("DEBUG: Date:", currentSelectedDate);
        console.log("DEBUG: Formatted Date:", formattedDate);
        console.log("DEBUG: Has Mood Data:", hasMoodData);
        
        // Update modal content
        document.getElementById('modalDate').textContent = formattedDate;
        
        if (hasMoodData) {
            document.getElementById('modalMessage').textContent = 
                "You have recorded your mood for this day. What would you like to do?";
            
            document.getElementById('modalActions').innerHTML = `
                <button onclick="viewDailyDetails()" class="modal-btn primary">
                    <i class="fas fa-eye"></i> View Entry Details
                </button>
            `;
        } else {
            document.getElementById('modalMessage').textContent = 
                "You haven't recorded your mood for this day yet. Would you like to add one?";
            
            document.getElementById('modalActions').innerHTML = `
                <button onclick="addNewMood()" class="modal-btn primary">
                    <i class="fas fa-plus"></i> Add Mood Entry
                </button>
            `;
        }
        
        // Show modal
        document.getElementById('dailyMoodModal').style.display = 'flex';
    }
    
    // Navigate to view daily mood page
    function viewDailyDetails() {
        console.log("DEBUG: viewDailyDetails called for date:", currentSelectedDate);
        if (currentSelectedDate) {
            window.location.href = '<%= request.getContextPath() %>/mood?action=viewDaily&date=' + currentSelectedDate;
        }
    }
    
    // Navigate to add mood page
    function addNewMood() {
        console.log("DEBUG: addNewMood called for date:", currentSelectedDate);
        if (currentSelectedDate) {
            window.location.href = '<%= request.getContextPath() %>/mood?action=add&date=' + currentSelectedDate;
        } else {
            window.location.href = '<%= request.getContextPath() %>/mood?action=add';
        }
    }
    
    // Navigate to edit mood page (you'll need to pass entry ID)
    function editMoodEntry() {
        // For now, redirect to add page with date
        // In a real implementation, you'd need to know the entry ID
        if (currentSelectedDate) {
            window.location.href = '<%= request.getContextPath() %>/mood?action=add&date=' + currentSelectedDate + '&edit=true';
        }
    }
    
    // Close modal
    function closeModal() {
        document.getElementById('dailyMoodModal').style.display = 'none';
        currentSelectedDate = '';
    }
    
    // Change time period
    function changePeriod(period) {
        window.location.href = '<%= request.getContextPath() %>/mood?action=viewTrends&period=' + period;
    }
    
    // Add click event listeners to all calendar days
    document.addEventListener('DOMContentLoaded', function() {
        console.log("DEBUG: DOM loaded, adding click listeners");
        
        // For weekly view days
        const weekDays = document.querySelectorAll('.day-column');
        weekDays.forEach(day => {
            day.addEventListener('click', function() {
                showDateMood(this);
            });
        });
        
        // For monthly view days
        const monthDays = document.querySelectorAll('.calendar-day');
        monthDays.forEach(day => {
            day.addEventListener('click', function() {
                showDateMood(this);
            });
        });
        
        console.log("DEBUG: Added click listeners to", weekDays.length + monthDays.length, "elements");
    });
    
    // Close modal when clicking outside
    document.addEventListener('click', function(event) {
        const modal = document.getElementById('dailyMoodModal');
        if (event.target === modal) {
            closeModal();
        }
    });
    
    // Close modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeModal();
        }
    });

    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            window.location.reload();
        }
    });

    // Check URL for delete success parameter
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('deleted') && urlParams.get('deleted') === 'true') {
        // Force reload to show updated data
        setTimeout(function() {
            const newUrl = window.location.pathname + '?action=viewTrends&t=' + new Date().getTime();
            window.history.replaceState({}, '', newUrl);
            location.reload();
        }, 100);
    }

    // Prevent caching
    if (!urlParams.has('t')) {
        const currentUrl = window.location.href;
        const separator = currentUrl.includes('?') ? '&' : '?';
        const newUrl = currentUrl + separator + 't=' + new Date().getTime();
        window.history.replaceState({}, '', newUrl);
    }
</script>

</body>
</html>