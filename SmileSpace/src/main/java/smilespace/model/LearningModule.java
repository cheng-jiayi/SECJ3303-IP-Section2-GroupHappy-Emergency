package smilespace.model;

import java.sql.Timestamp;

public class LearningModule {
    private String id;
    private String title;
    private String description;
    private String category;
    private String level;
    private String authorName;
    private String estimatedDuration;
    private String coverImage;
    private String resourceFile;
    private String videoUrl;
    private String contentOutline;
    private String learningGuide;
    private String learningTip;
    private String keyPoints;
    private String notes;
    private int views;
    private String lastUpdated;
    private Integer createdBy;
    private Timestamp createdAt;
    
    public LearningModule() {
        this.views = 0;
        this.lastUpdated = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    }
    
    public LearningModule(String id, String title, String category, String level, 
                         int views, String lastUpdated) {
        this.id = id;
        this.title = title;
        this.category = category;
        this.level = level;
        this.views = views;
        this.lastUpdated = lastUpdated;
    }
    
    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    
    public String getEstimatedDuration() { return estimatedDuration; }
    public void setEstimatedDuration(String estimatedDuration) { this.estimatedDuration = estimatedDuration; }
    
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    
    public String getResourceFile() { return resourceFile; }
    public void setResourceFile(String resourceFile) { this.resourceFile = resourceFile; }
    
    public String getVideoUrl() { return videoUrl; }
    public void setVideoUrl(String videoUrl) { this.videoUrl = videoUrl; }
    
    public String getContentOutline() { return contentOutline; }
    public void setContentOutline(String contentOutline) { this.contentOutline = contentOutline; }
    
    public String getLearningGuide() { return learningGuide; }
    public void setLearningGuide(String learningGuide) { this.learningGuide = learningGuide; }
    
    public String getLearningTip() { return learningTip; }
    public void setLearningTip(String learningTip) { this.learningTip = learningTip; }
    
    public String getKeyPoints() { return keyPoints; }
    public void setKeyPoints(String keyPoints) { this.keyPoints = keyPoints; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }
    
    public String getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(String lastUpdated) { this.lastUpdated = lastUpdated; }
    
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String[] getContentOutlineArray() {
        if (contentOutline == null || contentOutline.trim().isEmpty()) {
            return new String[0];
        }
        return contentOutline.split("\\$\\$");
    }
    
    public String[] getLearningGuideArray() {
        if (learningGuide == null || learningGuide.trim().isEmpty()) {
            return new String[0];
        }
        return learningGuide.split("\\$\\$");
    }
    
    public String[] getKeyPointsArray() {
        if (keyPoints == null || keyPoints.trim().isEmpty()) {
            return new String[0];
        }
        return keyPoints.split("\\$\\$");
    }
    
    @Override
    public String toString() {
        return "LearningModule{id='" + id + "', title='" + title + "', category='" + category + "'}";
    }
}