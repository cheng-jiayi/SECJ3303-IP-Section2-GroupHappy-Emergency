package smilespace.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class MoodEntry {
    private int entryId;
    private int userId;
    private LocalDate entryDate;
    private List<String> feelings;
    private String reflection;
    private Set<String> tags;
    private String imagePath;
    private LocalDate createdAt;
    
    // Student info for display
    private String studentName;
    private String studentMatric;
    private String studentProgram;
    private Integer studentYear;
    
    // Constructors
    public MoodEntry() {
        this.entryDate = LocalDate.now();
        this.feelings = new ArrayList<>();
        this.tags = new HashSet<>();
        this.createdAt = LocalDate.now();
    }
    
    public MoodEntry(int userId) {
        this();
        this.userId = userId;
    }
    
    public MoodEntry(int userId, LocalDate entryDate) {
        this();
        this.userId = userId;
        this.entryDate = entryDate;
    }
    
    // Getters and Setters
    public int getEntryId() { return entryId; }
    public void setEntryId(int entryId) { this.entryId = entryId; }
    
    public int getId() { return entryId; }
    public void setId(int id) { this.entryId = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public LocalDate getEntryDate() { return entryDate; }
    public void setEntryDate(LocalDate entryDate) { this.entryDate = entryDate; }
    
    public List<String> getFeelings() { return feelings; }
    public void setFeelings(List<String> feelings) { this.feelings = feelings; }
    
    public String getReflection() { return reflection; }
    public void setReflection(String reflection) { this.reflection = reflection; }
    
    public Set<String> getTags() { return tags; }
    public void setTags(Set<String> tags) { this.tags = tags; }
    
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    
    public LocalDate getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDate createdAt) { this.createdAt = createdAt; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getStudentMatric() { return studentMatric; }
    public void setStudentMatric(String studentMatric) { this.studentMatric = studentMatric; }
    
    public String getStudentProgram() { return studentProgram; }
    public void setStudentProgram(String studentProgram) { this.studentProgram = studentProgram; }
    
    public Integer getStudentYear() { return studentYear; }
    public void setStudentYear(Integer studentYear) { this.studentYear = studentYear; }
    
    // Helper methods
    public String getFeelingsAsString() {
        if (feelings == null || feelings.isEmpty()) return "No feelings recorded";
        List<String> capitalized = new ArrayList<>();
        for (String feeling : feelings) {
            if (feeling != null && !feeling.trim().isEmpty()) {
                capitalized.add(feeling.substring(0, 1).toUpperCase() + feeling.substring(1));
            }
        }
        return String.join(", ", capitalized);
    }
    
    public String getTagsAsString() {
        if (tags == null || tags.isEmpty()) return "";
        List<String> tagList = new ArrayList<>();
        for (String tag : tags) {
            tagList.add(tag.replace("_", " "));
        }
        return String.join(", ", tagList);
    }
    
    public String getFormattedDate() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("d MMM yyyy");
        return entryDate.format(formatter);
    }
    
    public String getDayOfWeek() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE");
        return entryDate.format(formatter);
    }
    
    public String getShortDate() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM");
        return entryDate.format(formatter);
    }
    
    public String getStudentInfo() {
        if (studentName != null && studentMatric != null) {
            return studentName + " (" + studentMatric + ")";
        }
        return studentName != null ? studentName : "Unknown Student";
    }
    
    public String getProgramYear() {
        if (studentProgram != null && studentYear != null) {
            return studentProgram + " / Year " + studentYear;
        } else if (studentProgram != null) {
            return studentProgram;
        }
        return "";
    }
    
    public boolean isRecent() {
        LocalDate today = LocalDate.now();
        return entryDate.equals(today) || entryDate.equals(today.minusDays(1));
    }
    
    public boolean hasTag(String tag) {
        return tags != null && tags.contains(tag);
    }
    
    public boolean hasFeeling(String feeling) {
        return feelings != null && feelings.contains(feeling.toLowerCase());
    }
    
    public String getFeelingImageUrl(String feeling) {
        String[] availableFeelings = {"neutral", "excited", "warm", "anxious", "stressed", 
                                      "relaxed", "happy", "sad", "playful"};
        
        for (String available : availableFeelings) {
            if (available.equalsIgnoreCase(feeling)) {
                return feeling.toLowerCase() + ".png";
            }
        }
        return "neutral.png";
    }
    
    public List<String> getFeelingImageUrls() {
        List<String> urls = new ArrayList<>();
        if (feelings != null) {
            for (String feeling : feelings) {
                urls.add(getFeelingImageUrl(feeling));
            }
        }
        return urls;
    }
    
    public String getPrimaryFeelingImageUrl() {
        if (feelings != null && !feelings.isEmpty()) {
            return getFeelingImageUrl(feelings.get(0));
        }
        return getFeelingImageUrl("neutral");
    }
    
    public String getReflectionPreview() {
        if (reflection == null || reflection.isEmpty()) return "No reflection provided";
        if (reflection.length() <= 100) return reflection;
        return reflection.substring(0, 100) + "...";
    }
}