package smilespace.model;

import java.time.LocalDate;

public class Student {
    private int userId;
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String matricNumber;
    private String program;
    private int year;
    private boolean isActive;
    private LocalDate lastLogin;
    private String recentMood;
    private String riskLevel;
    private String assessmentCategory;
    private int moodEntryCount;
    private String frequentTags;
    private double moodStability;

    // Constructors
    public Student() {}

    public Student(int userId, String fullName, String matricNumber, String program, int year) {
        this.userId = userId;
        this.fullName = fullName;
        this.matricNumber = matricNumber;
        this.program = program;
        this.year = year;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getName() { return fullName; }
    public void setName(String name) { this.fullName = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getMatricNumber() { return matricNumber; }
    public void setMatricNumber(String matricNumber) { this.matricNumber = matricNumber; }

    public String getProgram() { return program; }
    public void setProgram(String program) { this.program = program; }

    public String getProgramYear() { 
        return program + " / Year " + year;
    }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public LocalDate getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDate lastLogin) { this.lastLogin = lastLogin; }

    public String getRecentMood() { return recentMood; }
    public void setRecentMood(String recentMood) { this.recentMood = recentMood; }

    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }

    public String getAssessmentCategory() { return assessmentCategory; }
    public void setAssessmentCategory(String assessmentCategory) { 
        this.assessmentCategory = assessmentCategory; 
    }

    public int getMoodEntryCount() { return moodEntryCount; }
    public void setMoodEntryCount(int moodEntryCount) { this.moodEntryCount = moodEntryCount; }

    public String getFrequentTags() { return frequentTags; }
    public void setFrequentTags(String frequentTags) { this.frequentTags = frequentTags; }

    public double getMoodStability() { return moodStability; }
    public void setMoodStability(double moodStability) { this.moodStability = moodStability; }

    public String getMoodStabilityText() {
        if (moodStability >= 70) return "Stable";
        else if (moodStability >= 40) return "Moderate";
        else return "Unstable";
    }

    public String getStudentId() { // For JSP compatibility
        return "STU" + String.format("%03d", userId);
    }
}