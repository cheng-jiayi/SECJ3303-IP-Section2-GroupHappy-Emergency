package smilespace.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;

public class CounselingSession {
    private int sessionId;
    private int studentId;
    private Integer counselorId;
    private LocalDateTime scheduledDateTime;
    private LocalDateTime actualDateTime;
    private String sessionType;
    private String status;
    private String meetingLink;
    private String meetingLocation; 
    private String sessionSummary;
    private String observedMood;
    private String progressNotes;
    private String followUpActions;
    private String attachmentPath;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Additional fields for student booking
    private String currentMood;
    private String reason;
    private String additionalNotes;
    private String followUpMethod;
    private LocalDateTime nextSessionSuggested;
    private String studentName;
    private String studentEmail;
    private String counselorName;
    
    
    // Constructors
    public CounselingSession() {
        this.counselorId = null; 
        this.status = "Pending Assignment";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public CounselingSession(int studentId, Integer counselorId, LocalDateTime scheduledDateTime) {
        this();
        this.studentId = studentId;
        this.counselorId = counselorId;
        this.scheduledDateTime = scheduledDateTime;
    }
    
    // Getters and Setters
    public int getSessionId() { return sessionId; }
    public void setSessionId(int sessionId) { this.sessionId = sessionId; }
    
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    
    public Integer getCounselorId() { return counselorId; }
    public void setCounselorId(Integer counselorId) { this.counselorId = counselorId; }
    
    public LocalDateTime getScheduledDateTime() { return scheduledDateTime; }
    public void setScheduledDateTime(LocalDateTime scheduledDateTime) { 
        this.scheduledDateTime = scheduledDateTime; 
    }
    
    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { 
        this.status = status; 
        this.updatedAt = LocalDateTime.now();
    }
    
    public String getSessionSummary() { return sessionSummary; }
    public void setSessionSummary(String sessionSummary) { this.sessionSummary = sessionSummary; }
    
    public String getObservedMood() { return observedMood; }
    public void setObservedMood(String observedMood) { this.observedMood = observedMood; }
    
    public String getProgressNotes() { return progressNotes; }
    public void setProgressNotes(String progressNotes) { this.progressNotes = progressNotes; }
    
    public String getFollowUpActions() { return followUpActions; }
    public void setFollowUpActions(String followUpActions) { this.followUpActions = followUpActions; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public String getCurrentMood() { return currentMood; }
    public void setCurrentMood(String currentMood) { this.currentMood = currentMood; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public String getAdditionalNotes() { return additionalNotes; }
    public void setAdditionalNotes(String additionalNotes) { this.additionalNotes = additionalNotes; }
    
    public String getFollowUpMethod() { return followUpMethod; }
    public void setFollowUpMethod(String followUpMethod) { this.followUpMethod = followUpMethod; }
    
    public LocalDateTime getNextSessionSuggested() { return nextSessionSuggested; }
    public void setNextSessionSuggested(LocalDateTime nextSessionSuggested) { 
        this.nextSessionSuggested = nextSessionSuggested; 
    }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
    
    public String getCounselorName() { return counselorName; }
    public void setCounselorName(String counselorName) { this.counselorName = counselorName; }
    
    // Helper methods
    public String getFormattedDateTime() {
        if (scheduledDateTime == null) return "Not scheduled";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
        return scheduledDateTime.format(formatter);
    }
    
    public String getNextSessionFormatted() {
        if (nextSessionSuggested == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy, h:mm a");
        return nextSessionSuggested.format(formatter);
    }
    
    public boolean isScheduled() {
        return "Scheduled".equalsIgnoreCase(status) || 
            "Pending Assignment".equalsIgnoreCase(status) ||
            "Assigned".equalsIgnoreCase(status);
    }
    
    public boolean isCompleted() {
        return "Completed".equalsIgnoreCase(status);
    }
    
    public boolean isCancelled() {
        return "Cancelled".equalsIgnoreCase(status);
    }
    
    public boolean isAssignedTo(int userId) {
        return counselorId != null && counselorId.intValue() == userId;
    }

    public String getMeetingLink() { 
       return meetingLink; 
    }

    public void setMeetingLink(String meetingLink) { 
        this.meetingLink = meetingLink; 
    }

    public String getMeetingLocation() {
        return meetingLocation;
    }
    
    public void setMeetingLocation(String meetingLocation) {
        this.meetingLocation = meetingLocation;
    }

    public LocalDateTime getActualDateTime() { 
        return actualDateTime; 
    }

    public void setActualDateTime(LocalDateTime actualDateTime) { 
        this.actualDateTime = actualDateTime; 
    }

    public String getAttachmentPath() { 
        return attachmentPath; 
    }

    public void setAttachmentPath(String attachmentPath) { 
        this.attachmentPath = attachmentPath; 
    }
}