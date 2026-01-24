package smilespace.model;

import java.time.LocalDateTime;

public class Referral {
    private int referralId;
    private int studentId;
    private int facultyId;
    private String studentName;
    private String studentMatric;
    private String facultyName;
    private String reason;
    private String urgency;
    private String notes;
    private LocalDateTime referralDate;
    private String status;
    private Integer counselorId;
    private String counselorName;
    
    // Additional student information fields
    private String studentEmail;
    private String studentPhone;
    private String studentFaculty;
    private int studentYear;
    private String recentMood;
    private String riskLevel;
    private String frequentTags;
    private double moodStability;
    private String assessmentCategory;
    private String counselorEmail;
    
    // Add notify field for JSP compatibility
    private String notify;
    
    // Constants for status and urgency
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_ACCEPTED = "ACCEPTED";
    public static final String STATUS_COMPLETED = "COMPLETED";
    public static final String STATUS_REJECTED = "REJECTED";
    
    public static final String URGENCY_HIGH = "HIGH";
    public static final String URGENCY_MEDIUM = "MEDIUM";
    public static final String URGENCY_LOW = "LOW";
    
    // Constructors
    public Referral() {
        this.status = STATUS_PENDING;
        this.referralDate = LocalDateTime.now();
    }
    
    // Getters and Setters
    public int getReferralId() { return referralId; }
    public void setReferralId(int referralId) { this.referralId = referralId; }
    
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    
    public int getFacultyId() { return facultyId; }
    public void setFacultyId(int facultyId) { this.facultyId = facultyId; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getStudentMatric() { return studentMatric; }
    public void setStudentMatric(String studentMatric) { this.studentMatric = studentMatric; }
    
    public String getFacultyName() { return facultyName; }
    public void setFacultyName(String facultyName) { this.facultyName = facultyName; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { 
        this.urgency = urgency; 
    }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public LocalDateTime getReferralDate() { return referralDate; }
    public void setReferralDate(LocalDateTime referralDate) { this.referralDate = referralDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Integer getCounselorId() { return counselorId; }
    public void setCounselorId(Integer counselorId) { this.counselorId = counselorId; }
    
    public String getCounselorName() { return counselorName; }
    public void setCounselorName(String counselorName) { this.counselorName = counselorName; }
    
    // Getters and Setters for additional fields
    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
    
    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }
    
    public String getStudentFaculty() { return studentFaculty; }
    public void setStudentFaculty(String studentFaculty) { this.studentFaculty = studentFaculty; }
    
    public int getStudentYear() { return studentYear; }
    public void setStudentYear(int studentYear) { this.studentYear = studentYear; }
    
    public String getRecentMood() { return recentMood; }
    public void setRecentMood(String recentMood) { this.recentMood = recentMood; }
    
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
    
    public String getFrequentTags() { return frequentTags; }
    public void setFrequentTags(String frequentTags) { this.frequentTags = frequentTags; }
    
    public double getMoodStability() { return moodStability; }
    public void setMoodStability(double moodStability) { this.moodStability = moodStability; }
    
    public String getAssessmentCategory() { return assessmentCategory; }
    public void setAssessmentCategory(String assessmentCategory) { this.assessmentCategory = assessmentCategory; }
    
    public String getCounselorEmail() { return counselorEmail; }
    public void setCounselorEmail(String counselorEmail) { this.counselorEmail = counselorEmail; }
    
    // Add getters and setters for notify
    public String getNotify() { return notify; }
    public void setNotify(String notify) { this.notify = notify; }
    
    // Helper methods
    public String getFormattedDate() {
        if (referralDate == null) return "";
        java.time.format.DateTimeFormatter formatter = 
            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return referralDate.format(formatter);
    }
    
    public String getFormattedDateTime() {
        if (referralDate == null) return "";
        java.time.format.DateTimeFormatter formatter = 
            java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
        return referralDate.format(formatter);
    }
    
    public String getUrgencyColor() {
        if ("HIGH".equalsIgnoreCase(urgency)) return "high";
        if ("MEDIUM".equalsIgnoreCase(urgency)) return "medium";
        return "low";
    }
    
    public boolean isPending() {
        return STATUS_PENDING.equalsIgnoreCase(this.status);
    }
    
    public boolean isAccepted() {
        return STATUS_ACCEPTED.equalsIgnoreCase(this.status);
    }
    
    public boolean isCompleted() {
        return STATUS_COMPLETED.equalsIgnoreCase(this.status);
    }
    
    public boolean isRejected() {
        return STATUS_REJECTED.equalsIgnoreCase(this.status);
    }
    
    public String getFacultyYear() {
        if (studentFaculty != null && studentYear > 0) {
            return studentFaculty + " / Year " + studentYear;
        }
        return studentFaculty != null ? studentFaculty : "Not specified";
    }
}
